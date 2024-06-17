# app@uniparthenope  

app@uniparthenope è un'applicazione mobile sviluppata utilizzando Flutter, progettata per gli studenti e i docenti e il PTA dell'Università Parthenope. L'app offre una serie di servizi utili come la visualizzazione della carriera accademica, l'accesso ai corsi, la gestione delle tasse universitarie e un servizio meteo integrato e un servizio bibliotecario.

## Caratteristiche

- **Autenticazione**: Login tramite credenziali universitarie e utilizzo FaceID.
- **Carriera**: Visualizzazione degli esami superati e del percorso accademico.
- **Corsi**: Accesso ai corsi per ogni anno accademico.
- **Tasse**: Monitoraggio della situazione delle tasse universitarie.
- **Meteo**: Servizio meteo dell'Università Parthenope.
- **Disponibilità Aule (per Docenti)**: Visualizzazione e prenotazione delle aule.
- **Ricerca Eventi (per Docenti)**: Visualizzazione degli eventi orgnaizzati dall'univeristà.

## Tecnologie Utilizzate

- **Flutter**: Framework utilizzato per lo sviluppo dell'app.
- **Provider**: Gestione dello stato dell'app.
- **HTTP**: Comunicazione con i servizi backend dell'università (API's Uniparthenope).
- **Shared Preferences**: Salvataggio delle credenziali di login in modo sicuro.
- **Local Authentication**: Supporto per l'autenticazione biometrica (impronta digitale/riconoscimento facciale).

## Installazione

1. **Prerequisiti**:
    - [Flutter](https://flutter.dev/docs/get-started/install) installato sul proprio sistema.
    - Un emulatore Android/iOS configurato o un dispositivo fisico collegato.

2. **Clonare il Repository**:
    ```sh
    git clone https://github.com/username/UniParthenopeApp.git
    cd UniParthenopeApp
    ```

3. **Installare le Dipendenze**:
    ```sh
    flutter pub get
    ```

4. **Eseguire l'App**:
    ```sh
    flutter run
    ```

## Struttura del Progetto

- **lib/**: Contiene il codice sorgente dell'app.
  - **main.dart**: Punto di ingresso dell'app.
  - **models/**: Modelli dei dati.
  - **controller/**: Funzioni per la corretta implementazione della logica dei dati.
  - **providers/**: Provider per la gestione dello stato.
  - **screens/**: Schermate dell'app.
  - **services/**: Funzioni di servizio per interfacciarsi con l'API dell'università.
  - **utilityFunctions/**: Funzioni utili da utilizzare nei widget.
  - **widgets/**: Widget personalizzati utilizzati nell'app.
  - **app_routes.dart**: Rotte definite.

## Contribuire

Contributi, bug report e richieste di funzionalità sono benvenuti!

1. Fork il progetto
2. Crea un branch per la tua funzionalità (`git checkout -b feature/feature-name`)
3. Fai il commit delle tue modifiche (`git commit -m 'Add some feature'`)
4. Fai il push al branch (`git push origin feature/feature-name`)
5. Apri una Pull Request

## Licenza

Questo progetto è licenziato sotto la licenza MIT. Vedi il file [LICENSE](LICENSE) per maggiori dettagli.

## Contatti

Per ulteriori informazioni, domande o suggerimenti, contattami all'indirizzo email: [tuoemail@example.com](mailto:carminecoppola917@gmail.com).
