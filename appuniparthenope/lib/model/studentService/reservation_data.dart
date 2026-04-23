import 'dart:convert';

import 'package:intl/intl.dart';

class ReservationInfo {
  final int? adId;
  final int? appId;
  final int? adsceId;
  final int? appLogId;
  final int? appListaId;
  final int? cdsEsaId;
  final String? nomeAppello;
  final String? nomePres;
  final String? cognomePres;
  final int? numIscritti;
  final String? note;
  final String? statoDes;
  final Stato? statoEsito;
  final Stato? statoVerb;
  final Stato? statoPubbl;
  final TipoApp? tipoApp;
  final int? aulaId;
  final EdificioId? edificioId;
  final EdificioDes? edificioDes;
  final String? aulaDes;
  final String? desApp;
  final String? dataEsa;

  ReservationInfo({
    this.adId,
    this.appId,
    this.adsceId,
    this.appLogId,
    this.appListaId,
    this.cdsEsaId,
    this.nomeAppello,
    this.nomePres,
    this.cognomePres,
    this.numIscritti,
    this.note,
    this.statoDes,
    this.statoEsito,
    this.statoVerb,
    this.statoPubbl,
    this.tipoApp,
    this.aulaId,
    this.edificioId,
    this.edificioDes,
    this.aulaDes,
    this.desApp,
    this.dataEsa,
  });

  ReservationInfo copyWith({
    int? adId,
    int? appId,
    int? adsceId,
    int? appLogId,
    int? appListaId,
    int? cdsEsaId,
    String? nomeAppello,
    String? nomePres,
    String? cognomePres,
    int? numIscritti,
    String? note,
    String? statoDes,
    Stato? statoEsito,
    Stato? statoVerb,
    Stato? statoPubbl,
    TipoApp? tipoApp,
    int? aulaId,
    EdificioId? edificioId,
    EdificioDes? edificioDes,
    String? aulaDes,
    String? desApp,
    String? dataEsa,
  }) =>
      ReservationInfo(
        adId: adId ?? this.adId,
        appId: appId ?? this.appId,
        adsceId: adsceId ?? this.adsceId,
        appLogId: appLogId ?? this.appLogId,
        appListaId: appListaId ?? this.appListaId,
        cdsEsaId: cdsEsaId ?? this.cdsEsaId,
        nomeAppello: nomeAppello ?? this.nomeAppello,
        nomePres: nomePres ?? this.nomePres,
        cognomePres: cognomePres ?? this.cognomePres,
        numIscritti: numIscritti ?? this.numIscritti,
        note: note ?? this.note,
        statoDes: statoDes ?? this.statoDes,
        statoEsito: statoEsito ?? this.statoEsito,
        statoVerb: statoVerb ?? this.statoVerb,
        statoPubbl: statoPubbl ?? this.statoPubbl,
        tipoApp: tipoApp ?? this.tipoApp,
        aulaId: aulaId ?? this.aulaId,
        edificioId: edificioId ?? this.edificioId,
        edificioDes: edificioDes ?? this.edificioDes,
        aulaDes: aulaDes ?? this.aulaDes,
        desApp: desApp ?? this.desApp,
        dataEsa: dataEsa ?? this.dataEsa,
      );

  factory ReservationInfo.fromRawJson(String str) =>
      ReservationInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReservationInfo.fromJson(Map<String, dynamic> json) =>
      ReservationInfo(
        adId: json["adId"] ?? 0,
        appId: json["appId"] ?? 0,
        adsceId: _parseInt(json["adsceId"] ?? json["ADSCE_ID"]),
        appLogId: _parseInt(json["appLogId"] ?? json["APP_LOG_ID"]),
        appListaId: _parseInt(json["appListaId"] ?? json["APP_LISTA_ID"]),
        cdsEsaId: _parseInt(json["cdsEsaId"] ?? json["CDS_ESA_ID"]),
        nomeAppello: json["nomeAppello"] ?? '',
        nomePres: json["nome_pres"] ?? '',
        cognomePres: json["cognome_pres"] ?? '',
        numIscritti: json["numIscritti"] ?? 0,
        note: json["note"] ?? '',
        statoDes: json["statoDes"] ?? '',
        statoEsito:
            statoValues.map[json["statoEsito"]] ?? Stato.A, // Default value
        statoVerb:
            statoValues.map[json["statoVerb"]] ?? Stato.A, // Default value
        statoPubbl:
            statoValues.map[json["statoPubbl"]] ?? Stato.A, // Default value
        tipoApp: tipoAppValues.map[json["tipoApp"]] ??
            TipoApp.APPELLO_CON_FIRMA_DIGITALE_REMOTA, // Default value
        aulaId: json["aulaId"] ?? 0,
        edificioId: edificioIdValues.map[json["edificioId"]] ??
            EdificioId.EMPTY, // Default value
        edificioDes: edificioDesValues.map[json["edificioDes"]] ??
            EdificioDes.EMPTY, // Default value
        aulaDes: json["aulaDes"] ?? '',
        desApp: json["desApp"] ?? '',
        dataEsa: json["dataEsa"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "adId": adId,
        "appId": appId,
        "adsceId": adsceId,
        "appLogId": appLogId,
        "appListaId": appListaId,
        "cdsEsaId": cdsEsaId,
        "nomeAppello": nomeAppello,
        "nome_pres": nomePres,
        "cognome_pres": cognomePres,
        "numIscritti": numIscritti,
        "note": note,
        "statoDes": statoDes,
        "statoEsito": statoValues.reverse[statoEsito],
        "statoVerb": statoValues.reverse[statoVerb],
        "statoPubbl": statoValues.reverse[statoPubbl],
        "tipoApp": tipoAppValues.reverse[tipoApp],
        "aulaId": aulaId,
        "edificioId": edificioIdValues.reverse[edificioId],
        "edificioDes": edificioDesValues.reverse[edificioDes],
        "aulaDes": aulaDes,
        "desApp": desApp,
        "dataEsa": dataEsa,
      };

  // Metodo per convertire la stringa di data in un oggetto DateTime
  DateTime? getDateTimeFromString() {
    if (dataEsa != null) {
      return DateFormat('yyyy-MM-dd').parse(dataEsa!);
    }
    return null;
  }

  Uri? buildEsse3CancellationUri({
    required int fallbackCdsId,
    required int fallbackAdsceId,
  }) {
    final appIdValue = appId;
    final adIdValue = adId;
    final appListaIdValue = appListaId;

    if (appIdValue == null ||
        adIdValue == null ||
        appListaIdValue == null ||
        appIdValue == 0 ||
        adIdValue == 0 ||
        appListaIdValue == 0) {
      return null;
    }

    return Uri.https(
      'uniparthenope.esse3.cineca.it',
      '/auth/studente/Appelli/ConfermaCancellaAppello.do',
      {
        'APP_ID': appIdValue.toString(),
        'CDS_ESA_ID': (cdsEsaId ?? fallbackCdsId).toString(),
        'ATT_DID_ESA_ID': adIdValue.toString(),
        'APP_LOG_ID': (appLogId ?? 1).toString(),
        'ADSCE_ID': (adsceId ?? fallbackAdsceId).toString(),
        'APP_LISTA_ID': appListaIdValue.toString(),
        'return': 'BACHECA',
      },
    );
  }
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

enum EdificioDes { CENTRO_DIREZIONALE, EMPTY, TRAMITE_MICROSOFT_TEAMS }

final edificioDesValues = EnumValues({
  "CENTRO DIREZIONALE": EdificioDes.CENTRO_DIREZIONALE,
  "": EdificioDes.EMPTY,
  "TRAMITE MICROSOFT TEAMS": EdificioDes.TRAMITE_MICROSOFT_TEAMS
});

enum EdificioId { CDLE, EMPTY, MT }

final edificioIdValues = EnumValues(
    {"CDLE": EdificioId.CDLE, "": EdificioId.EMPTY, "MT": EdificioId.MT});

enum Stato { A, C }

final statoValues = EnumValues({"A": Stato.A, "C": Stato.C});

enum TipoApp { APPELLO_CON_FIRMA_DIGITALE_REMOTA, PROVA_SENZA_VERBALIZZAZIONE }

final tipoAppValues = EnumValues({
  "Appello con Firma Digitale Remota":
      TipoApp.APPELLO_CON_FIRMA_DIGITALE_REMOTA,
  "Prova senza verbalizzazione": TipoApp.PROVA_SENZA_VERBALIZZAZIONE
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
