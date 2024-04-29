class ExamData {
  String? nome;
  String? codice;
  String? tipo;
  int? adId;
  int? adsceID;
  String? docente;
  String? docenteID;
  String? semestre;
  String? semestreDes;
  String? adLogId;
  String? domPartCod;
  //Status status;

  ExamData({
    required this.nome,
    required this.codice,
    required this.tipo,
    required this.adId,
    required this.adsceID,
    required this.docente,
    required this.docenteID,
    required this.semestre,
    required this.semestreDes,
    required this.adLogId,
    required this.domPartCod,
    //required this.status,
  });

  factory ExamData.fromJson(Map<String, dynamic> json) {
    try {
      return ExamData(
        nome: json['nome'] as String?,
        codice: json['codice'] as String?,
        tipo: json['tipo'] as String?,
        adId: json['adId'] as int?,
        adsceID: json['adsceID'] as int?,
        docente: json['docente'] as String?,
        docenteID: json['docenteID'] as String?,
        semestre: json['semestre'] as String?,
        semestreDes: json['semestreDes'] as String?,
        adLogId: json['adLogId'] as String?,
        domPartCod: json['domPartCod'] as String?,
        // status: json['status'] != null
        //     ? Status.fromJson(json['status'])
        //     : Status(esito: null, voto: null, lode: null, data: null),
      );
    } catch (e) {
      throw FormatException('Errore durante il parsing del JSON: $e');
    }
  }
}

class Status {
  String? esito;
  int? voto;
  int? lode;
  String? data;

  Status(
      {required this.esito,
      required this.voto,
      required this.lode,
      required this.data});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
        esito: json['esito'] as String?,
        voto: json['voto'] as int?,
        lode: json['lode'] as int?,
        data: json['data'] as String?);
  }
}




// class ExamData {
//   String? nome;
//   String? codice;
//   String? tipo;
//   int? adId;
//   int? adsceID;
//   String? docente;
//   String? docenteID;
//   String? semestre;
//   String? semestreDes;
//   String? adLogId;
//   String? domPartCod;
//   Status? status;
//   int? cfu;
//   int? annoId;
//   int? numAppelliPrenotabili;
//   String? tipoInsDes;
//   String? tipoInsCod;
//   String? tipoEsaDes;

//   ExamData(
//       {required this.nome,
//       required this.codice,
//       required this.tipo,
//       required this.adId,
//       required this.adsceID,
//       required this.docente,
//       required this.docenteID,
//       required this.semestre,
//       required this.semestreDes,
//       required this.adLogId,
//       required this.domPartCod,
//       required this.status,
//       required this.cfu,
//       required this.annoId,
//       required this.numAppelliPrenotabili,
//       required this.tipoInsDes,
//       required this.tipoInsCod,
//       required this.tipoEsaDes});

  // factory ExamData.fromJson(Map<String, dynamic> json) {
  //   try {
  //     return ExamData(
  //       nome: json['nome'] as String?,
  //       codice: json['codice'] as String?,
  //       tipo: json['tipo'] as String?,
  //       adId: json['adId'] as int?,
  //       adsceID: json['adsceID'] as int?,
  //       docente: json['docente'] as String?,
  //       docenteID: json['docenteID'] as String?,
  //       semestre: json['semestre'] as String?,
  //       semestreDes: json['semestreDes'] as String?,
  //       adLogId: json['adLogId'] as String?,
  //       domPartCod: json['domPartCod'] as String?,
  //       status: json['status'] != null ? Status.fromJson(json['status']) : null,
  //       cfu: json['CFU'] as int?,
  //       annoId: json['annoId'] as int?,
  //       numAppelliPrenotabili: json['numAppelliPrenotabili'] as int?,
  //       tipoInsDes: json['tipoInsDes'] as String?,
  //       tipoInsCod: json['tipoInsCod'] as String?,
  //       tipoEsaDes: json['tipoEsaDes'] as String?,
  //     );
  //   } catch (e) {
  //     throw FormatException('Errore durante il parsing del JSON: $e');
  //   }
//   }
// }

// class Status {
//   String? esito;
//   int? voto;
//   int? lode;
//   String? data;

//   Status(
//       {required this.esito,
//       required this.voto,
//       required this.lode,
//       required this.data});

//   factory Status.fromJson(Map<String, dynamic> json) {
//     try {
//       return Status(
//           esito: json['esito'] as String?,
//           voto: json['voto'] as int?,
//           lode: json['lode'] as int?,
//           data: json['data'] as String?);
//     } catch (e) {
//       throw FormatException('Errore durante il parsing del JSON STATUS: $e');
//     }
//   }
// }
