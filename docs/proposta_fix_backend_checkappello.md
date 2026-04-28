# Proposta PR Backend: Allineamento `checkAppello` con Esse3 Prenotabili

Repository target: [api-uniparthenope](https://github.com/uniparthenope/api-uniparthenope)

## Problema osservato
L'endpoint `GET /v1/students/checkAppello/{cdsId}/{adId}` oggi ritorna quasi tutti gli appelli escluso solo `stato = C`.
Di conseguenza arriva anche storico (es. `EP`, `EPV`, date passate), mentre in Esse3 l'utente vede solo appelli effettivamente prenotabili/attivi.

Nel codice attuale (`app/apis/uniparthenope/v1/students_v1.py`):

- `bad_status = ["C"]`
- filtro: `if _response[i]['stato'] not in bad_status`

## Obiettivo
Rendere `checkAppello` coerente con la UX Esse3:
- escludere appelli storici/chiusi
- mantenere solo appelli futuri o odierni
- includere solo stati operativi per prenotazione (tipicamente `P`, e opzionalmente `I` se previsto dal dominio)

## Patch suggerita (minima)

```python
# app/apis/uniparthenope/v1/students_v1.py
from datetime import datetime

...

class CheckAppello(Resource):
    @ns.doc(security='Basic Auth')
    @token_required
    def get(self, cdsId, adId):
        """Check Appello"""

        my_exams = []

        # Stati ammessi per appelli utili lato studente.
        # Se si vuole massima rigidità, usare solo {"P"}.
        allowed_status = {"P", "I"}

        headers = {
            'Content-Type': "application/json",
            "Authorization": "Basic " + g.token
        }

        try:
            response = requests.request(
                "GET",
                url + "calesa-service-v1/appelli/" + cdsId + "/" + adId,
                headers=headers,
                timeout=20
            )
            _response = response.json()

            if response.status_code == 200:
                today = datetime.now().date()

                for i in range(0, len(_response)):
                    stato = (_response[i].get('stato') or '').strip().upper()
                    if stato not in allowed_status:
                        continue

                    data_inizio_app = _response[i].get('dataInizioApp')
                    if not data_inizio_app:
                        continue

                    # Formato Esse3 tipico: "YYYY-MM-DD HH:MM:SS"
                    data_esame = datetime.strptime(
                        data_inizio_app.split()[0],
                        "%Y-%m-%d"
                    ).date()

                    # Solo appelli oggi/futuri
                    if data_esame < today:
                        continue

                    actual_exam = {
                        'esame': _response[i]['adDes'],
                        'appId': _response[i]['appId'],
                        'stato': _response[i]['stato'],
                        'statoDes': _response[i]['statoDes'],
                        'docente': _response[i]['presidenteCognome'].capitalize(),
                        'docente_completo': _response[i]['presidenteCognome'].capitalize() + " " + _response[i]['presidenteNome'].capitalize(),
                        'numIscritti': _response[i]['numIscritti'],
                        'note': _response[i]['note'],
                        'descrizione': _response[i]['desApp'],
                        'dataFine': _response[i]['dataFineIscr'].split()[0],
                        'dataInizio': _response[i]['dataInizioIscr'].split()[0],
                        'dataEsame': _response[i]['dataInizioApp'].split()[0],
                    }
                    my_exams.append(actual_exam)

                return my_exams, 200
            else:
                return {'errMsg': _response['retErrMsg']}, response.status_code

        ...
```

## Variante consigliata (più sicura)
Aggiungere un parametro query non-breaking per rollout graduale:
- `strict=1` => applica filtro nuovo
- default => comportamento attuale

Poi lato app usare `strict=1` solo sulla nuova pagina appelli per validazione progressiva.

## Test funzionali da eseguire
1. Utente con appelli prenotabili su Esse3:
   - `checkAppello` deve tornare solo appelli futuri e stati ammessi.
2. Utente con soli appelli storici:
   - deve tornare lista vuota.
3. Caso misto (`P`, `I`, `EP`, `EPV`, `C`):
   - devono passare solo `P/I` futuri.
4. Verifica regressione booking:
   - gli `appId` restituiti devono rimanere prenotabili da `bookExam`.

## Nota importante
Se anche con questo filtro `DIRITTO COMMERCIALE` non restituisce i 2 appelli visti su Esse3, allora il problema è sull'identificativo usato (`adId`) nella chiamata a `calesa-service-v1/appelli/{cdsId}/{adId}` e serve allineare la chiave applicativa corretta per quell'utenza.
