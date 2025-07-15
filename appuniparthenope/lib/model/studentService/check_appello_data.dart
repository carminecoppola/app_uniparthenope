class CheckAppello {
  String? esame;
  int? appId;
  String? stato;
  String? statoDes;
  String? docente;
  String? docenteCompleto;
  int? numIscritti;
  String? note;
  String? descrizione;
  String? dataFine;
  String? dataInizio;
  String? dataEsame;

  CheckAppello(
      {this.esame,
      this.appId,
      this.stato,
      this.statoDes,
      this.docente,
      this.docenteCompleto,
      this.numIscritti,
      this.note,
      this.descrizione,
      this.dataFine,
      this.dataInizio,
      this.dataEsame});

  CheckAppello.fromJson(Map<String, dynamic> json) {
    esame = json['esame'];
    appId = json['appId'];
    stato = json['stato'];
    statoDes = json['statoDes'];
    docente = json['docente'];
    docenteCompleto = json['docente_completo'];
    numIscritti = json['numIscritti'];
    note = json['note'];
    descrizione = json['descrizione'];
    dataFine = json['dataFine'];
    dataInizio = json['dataInizio'];
    dataEsame = json['dataEsame'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['esame'] = esame;
    data['appId'] = appId;
    data['stato'] = stato;
    data['statoDes'] = statoDes;
    data['docente'] = docente;
    data['docente_completo'] = docenteCompleto;
    data['numIscritti'] = numIscritti;
    data['note'] = note;
    data['descrizione'] = descrizione;
    data['dataFine'] = dataFine;
    data['dataInizio'] = dataInizio;
    data['dataEsame'] = dataEsame;
    return data;
  }
}
