class User {
  final String authToken;
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final String role;
  final int persId;
  final String aliasName;
  final String codFis;
  final List<TrattoCarriera> trattiCarriera;//Da vedere

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    required this.role,
    required this.persId,
    required this.authToken,
    required this.aliasName,
    required this.codFis,
    required this.trattiCarriera,
  });

  factory User.fromJson(Map<String, dynamic> userJson) {
    return User(
      id: userJson['user']['id'],
      firstName: userJson['user']['firstName'],
      lastName: userJson['user']['lastName'],
      username: userJson['user']['userId'],
      password: userJson['password'],
      role: userJson['user']['grpDes'],
      persId: userJson['user']['persId'],
      authToken: userJson['authToken'],
      aliasName: userJson['user']['aliasName'],
      codFis: userJson['user']['codFis'],
      trattiCarriera: List<TrattoCarriera>.from(userJson['user']
              ['trattiCarriera']
          .map((tratto) => TrattoCarriera.fromJson(tratto))),
    );
  }

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, username: $username, password: $password, role: $role, persId: $persId, authToken: $authToken, aliasName: $aliasName, codFis: $codFis, trattiCarriera: $trattiCarriera},';
  }
}

class TrattoCarriera {
  final String cdsDes;
  final String cdsCod;
  final String matricola;
  final String motStastuDes;
  final String staMatDes;
  final String staStuDes;

  TrattoCarriera({
    required this.cdsDes,
    required this.cdsCod,
    required this.matricola,
    required this.motStastuDes,
    required this.staMatDes,
    required this.staStuDes,
  });

  factory TrattoCarriera.fromJson(Map<String, dynamic> carrieraJson) {
    return TrattoCarriera(
      cdsDes: carrieraJson['cdsDes'],
      cdsCod: carrieraJson['cdsCod'],
      matricola: carrieraJson['matricola'],
      motStastuDes: carrieraJson['motStastuDes'],
      staMatDes: carrieraJson['staMatDes'],
      staStuDes: carrieraJson['staStuDes'],
    );
  }

  @override
  String toString() {
    return 'TrattoCarriera{cdsDes: $cdsDes, cdsCod: $cdsCod, matricola: $matricola, motStastuDes: $motStastuDes, staMatDes: $staMatDes, staStuDes: $staStuDes}';
  }
}

/*
class User {
  final String authToken;
  final String username;
  final String password;
  String aliasName;
  String codFis;
  int docenteId;
  String firstName;
  String grpDes;
  int grpId;
  int id;
  int idAb;
  String lastName;
  int persId;
  int sessionTimeout;
  String sex;
  int soggEstId;
  int tipoFirmaFaId;
  int tipoFirmaId;
  List<TrattoCarriera> trattiCarriera;

  User({
    required this.authToken,
    required this.username,
    required this.password,
    required this.aliasName,
    required this.codFis,
    required this.docenteId,
    required this.firstName,
    required this.grpDes,
    required this.grpId,
    required this.id,
    required this.idAb,
    required this.lastName,
    required this.persId,
    required this.sessionTimeout,
    required this.sex,
    required this.soggEstId,
    required this.tipoFirmaFaId,
    required this.tipoFirmaId,
    required this.trattiCarriera,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var trattiCarrieraList = json['trattiCarriera'] as List?;
    List<TrattoCarriera> trattiCarriera = trattiCarrieraList != null
        ? trattiCarrieraList
            .map((tratto) => TrattoCarriera.fromJson(tratto))
            .toList()
        : [];

    return User(
      authToken: json['authToken'],
      username: json['user']['userId'],
      password: json['password'],
      aliasName: json['aliasName'],
      codFis: json['codFis'],
      docenteId: json['docenteId'],
      firstName: json['firstName'],
      grpDes: json['grpDes'],
      grpId: json['grpId'],
      id: json['id'],
      idAb: json['idAb'],
      lastName: json['lastName'],
      persId: json['persId'],
      sessionTimeout: json['sessionTimeout'],
      sex: json['sex'],
      soggEstId: json['soggEstId'],
      tipoFirmaFaId: json['tipoFirmaFaId'],
      tipoFirmaId: json['tipoFirmaId'],
      trattiCarriera: trattiCarriera,
    );
  }
}

class TrattoCarriera {
  String cdsDes;
  int cdsId;
  List<DettaglioTratto>? dettaglioTratto;
  String matId;
  String matricola;
  String motStastuCod;
  String motStastuDes;
  String staMatCod;
  String staMatDes;
  String staStuCod;
  String staStuDes;
  int studId;
  String strutturaDes;
  String strutturaId;
  String strutturaGaId;
  String corsoGaId;

  TrattoCarriera({
    required this.cdsDes,
    required this.cdsId,
    required this.dettaglioTratto,
    required this.matId,
    required this.matricola,
    required this.motStastuCod,
    required this.motStastuDes,
    required this.staMatCod,
    required this.staMatDes,
    required this.staStuCod,
    required this.staStuDes,
    required this.studId,
    required this.strutturaDes,
    required this.strutturaId,
    required this.strutturaGaId,
    required this.corsoGaId,
  });

  factory TrattoCarriera.fromJson(Map<String, dynamic> json) {
    var dettaglioTrattoList = json['dettaglioTratto'] as List?;
    List<DettaglioTratto>? dettaglioTratto = dettaglioTrattoList != null
        ? dettaglioTrattoList
            .map((dettaglio) => DettaglioTratto.fromJson(dettaglio))
            .toList()
        : [];
    return TrattoCarriera(
      cdsDes: json['cdsDes'],
      cdsId: json['cdsId'],
      dettaglioTratto: dettaglioTratto,
      matId: json['cdsDes'],
      matricola: json['cdsId'],
      motStastuCod: json['cdsDes'],
      motStastuDes: json['cdsId'],
      staMatCod: json['staMatCod'],
      staMatDes: json['staMatDes'],
      staStuCod: json['staStuCod'],
      staStuDes: json['staStuDes'],
      studId: json['studId'],
      strutturaDes: json['strutturaDes'],
      strutturaId: json['strutturaId'],
      strutturaGaId: json['strutturaGaId'],
      corsoGaId: json['corsoGaId'],
    );
  }
}

class DettaglioTratto {
  int aaIscrId;
  int aaOrdId;
  int aaRegId;
  int anniFC;
  int annoCorso;
  String cdsCod;
  int cdsId;
  int condFlg;
  int domiscrFlg;
  int durataAnni;
  String facCod;
  int facId;
  int iscrId;
  int matId;
  int mobilFlg;
  String motStaiscrCod;
  String motStamatCod;
  String motStastuCod;
  int normId;
  int notaBloccanteFlg;
  int passaggioFlg;
  String pdsCod;
  int pdsId;
  String profCod;
  int ptFlg;
  String staIscrCod;
  String staMatCod;
  String staStuCod;
  int stuId;
  int tipoCatAmmId;
  String tipoCorsoCod;
  String tipoIscrCod;
  String tipoSpecCod;
  int ultimoAnnoFlg;

  DettaglioTratto({
    required this.aaIscrId,
    required this.aaOrdId,
    required this.aaRegId,
    required this.anniFC,
    required this.annoCorso,
    required this.cdsCod,
    required this.cdsId,
    required this.condFlg,
    required this.domiscrFlg,
    required this.durataAnni,
    required this.facCod,
    required this.facId,
    required this.iscrId,
    required this.matId,
    required this.mobilFlg,
    required this.motStaiscrCod,
    required this.motStamatCod,
    required this.motStastuCod,
    required this.normId,
    required this.notaBloccanteFlg,
    required this.passaggioFlg,
    required this.pdsCod,
    required this.pdsId,
    required this.profCod,
    required this.ptFlg,
    required this.staIscrCod,
    required this.staMatCod,
    required this.staStuCod,
    required this.stuId,
    required this.tipoCatAmmId,
    required this.tipoCorsoCod,
    required this.tipoIscrCod,
    required this.tipoSpecCod,
    required this.ultimoAnnoFlg,
  });

  factory DettaglioTratto.fromJson(Map<String, dynamic> json) {
    return DettaglioTratto(
      aaIscrId: json['aaIscrId'],
      aaOrdId: json['aaOrdId'],
      aaRegId: json['aaRegId'],
      anniFC: json['anniFC'],
      annoCorso: json['annoCorso'],
      cdsCod: json['cdsCod'],
      cdsId: json['cdsId'],
      condFlg: json['condFlg'],
      domiscrFlg: json['domiscrFlg'],
      durataAnni: json['durataAnni'],
      facCod: json['facCod'],
      facId: json['facId'],
      iscrId: json['iscrId'],
      matId: json['matId'],
      mobilFlg: json['mobilFlg'],
      motStaiscrCod: json['motStaiscrCod'],
      motStamatCod: json['motStamatCod'],
      motStastuCod: json['motStastuCod'],
      normId: json['normId'],
      notaBloccanteFlg: json['notaBloccanteFlg'],
      passaggioFlg: json['passaggioFlg'],
      pdsCod: json['pdsCod'],
      pdsId: json['pdsId'],
      profCod: json['profCod'],
      ptFlg: json['ptFlg'],
      staIscrCod: json['staIscrCod'],
      staMatCod: json['staMatCod'],
      staStuCod: json['staStuCod'],
      stuId: json['stuId'],
      tipoCatAmmId: json['tipoCatAmmId'],
      tipoCorsoCod: json['tipoCorsoCod'],
      tipoIscrCod: json['tipoIscrCod'],
      tipoSpecCod: json['tipoSpecCod'],
      ultimoAnnoFlg: json['ultimoAnnoFlg'],
    );
  }
}*/

/*
class User {
  final String authToken;
  final String username;
  final String password;

  String aliasName;
  String codFis;
  ng firstName;
  String grpDes;
  int grpId;
  int id;
  //dynamic idAb;
  String lastName;
  int persId;
  int sessionTimeout;
  String sex;
  //dynamic soggEstId;
  int tipoFirmaFaId;
  int tipoFirmaId;
  List<TrattiCarriera> trattiCarriera;
  String userId;

  User({
    required this.authToken,
    required this.username,
    required this.password,
    this.aliasName = "",
    required this.codFis,
    //this.docenteId = 0,
    required this.firstName,
    required this.grpDes,
    required this.grpId,
    required this.id,
    //this.idAb = 0,
    required this.lastName,
    required this.persId,
    required this.sessionTimeout,
    required this.sex,
    //this.soggEstId = 0,
    required this.tipoFirmaFaId,
    required this.tipoFirmaId,
    required this.trattiCarriera,
    required this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        authToken: json['authToken'],
        username: json['username'],
        password: json['password'],
        aliasName: json['aliasName'] ?? "",
        codFis: json['codFis'],
        //docenteId: json['docenteId'],
        firstName: json['firstName'],
        grpDes: json['grpDes'],
        grpId: json['grpId'],
        id: json['id'],
        //idAb: json['idAb'],
        lastName: json['lastName'],
        persId: json['persId'],
        sessionTimeout: json['sessionTimeout'],
        sex: json['sex'],
        //soggEstId: json['soggEstId'],
        tipoFirmaFaId: json['tipoFirmaFaId'],
        tipoFirmaId: json['tipoFirmaId'],
        // Mappa la lista trattiCarriera utilizzando la classe TrattiCarriera
        trattiCarriera: (json['trattiCarriera'] as List<dynamic>?)
                ?.map<TrattiCarriera>((x) => TrattiCarriera.fromJson(x))
                .toList() ??
            [],
        userId: json['userId'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "aliasName": aliasName,
        "codFis": codFis,
        //"docenteId": docenteId,
        "firstName": firstName,
        "grpDes": grpDes,
        "grpId": grpId,
        "id": id,
        //"idAb": idAb,
        "lastName": lastName,
        "persId": persId,
        "sessionTimeout": sessionTimeout,
        "sex": sex,
        //"soggEstId": soggEstId,
        "tipoFirmaFaId": tipoFirmaFaId,
        "tipoFirmaId": tipoFirmaId,
        "trattiCarriera":
            List<dynamic>.from(trattiCarriera.map((x) => x.toJson())),
        "userId": userId,
      };
}

class TrattiCarriera {
  String cdsDes;
  int cdsId;
  DettaglioTratto dettaglioTratto;
  int matId;
  String matricola;
  String motStastuCod;
  String motStastuDes;
  String staMatCod;
  String staMatDes;
  String staStuCod;
  String staStuDes;
  int stuId;
  String strutturaDes;
  String strutturaId;
  String strutturaGaId;
  String corsoGaId;

  TrattiCarriera({
    required this.cdsDes,
    required this.cdsId,
    required this.dettaglioTratto,
    required this.matId,
    required this.matricola,
    required this.motStastuCod,
    required this.motStastuDes,
    required this.staMatCod,
    required this.staMatDes,
    required this.staStuCod,
    required this.staStuDes,
    required this.stuId,
    this.strutturaDes = "",
    this.strutturaId = "",
    this.strutturaGaId = "",
    this.corsoGaId = "",
  });

  factory TrattiCarriera.fromJson(Map<String, dynamic> json) => TrattiCarriera(
        cdsDes: json['cdsDes'],
        cdsId: json['cdsId'],
        dettaglioTratto: DettaglioTratto.fromJson(json['dettaglioTratto']),
        matId: json['matId'],
        matricola: json['matricola'],
        motStastuCod: json['motStastuCod'],
        motStastuDes: json['motStastuDes'],
        staMatCod: json['staMatCod'],
        staMatDes: json['staMatDes'],
        staStuCod: json['staStuCod'],
        staStuDes: json['staStuDes'],
        stuId: json['stuId'],
        strutturaDes: json['strutturaDes'] ??
            "", // Utilizza una stringa vuota se strutturaDes è null
        strutturaId: json['strutturaId'] ??
            "", // Utilizza una stringa vuota se strutturaId è null
        strutturaGaId: json['strutturaGaId'] ??
            "", // Utilizza una stringa vuota se strutturaGaId è null
        corsoGaId: json['corsoGaId'] ??
            "", // Utilizza una stringa vuota se corsoGaId è null
      );

  Map<String, dynamic> toJson() => {
        "cdsDes": cdsDes,
        "cdsId": cdsId,
        "dettaglioTratto": dettaglioTratto.toJson(),
        "matId": matId,
        "matricola": matricola,
        "motStastuCod": motStastuCod,
        "motStastuDes": motStastuDes,
        "staMatCod": staMatCod,
        "staMatDes": staMatDes,
        "staStuCod": staStuCod,
        "staStuDes": staStuDes,
        "stuId": stuId,
        "strutturaDes": strutturaDes,
        "strutturaId": strutturaId,
        "strutturaGaId": strutturaGaId,
        "corsoGaId": corsoGaId,
      };
}

class DettaglioTratto {
  int aaIscrId;
  int aaOrdId;
  int aaRegId;
  int anniFc;
  int annoCorso;
  String cdsCod;
  int cdsId;
  int condFlg;
  int domiscrFlg;
  int durataAnni;
  String facCod;
  int facId;
  int iscrId;
  int matId;
  int mobilFlg;
  String motStaiscrCod;
  String motStamatCod;
  String motStastuCod;
  int normId;
  int notaBloccanteFlg;
  int passaggioFlg;
  String pdsCod;
  int pdsId;
  String profCod;
  int ptFlg;
  String staIscrCod;
  String staMatCod;
  String staStuCod;
  int stuId;
  //dynamic tipoCatAmmId;
  String tipoCorsoCod;
  String tipoIscrCod;
  String tipoSpecCod;
  int ultimoAnnoFlg;

  DettaglioTratto({
    required this.aaIscrId,
    required this.aaOrdId,
    required this.aaRegId,
    required this.anniFc,
    required this.annoCorso,
    required this.cdsCod,
    required this.cdsId,
    required this.condFlg,
    required this.domiscrFlg,
    required this.durataAnni,
    required this.facCod,
    required this.facId,
    required this.iscrId,
    required this.matId,
    required this.mobilFlg,
    required this.motStaiscrCod,
    this.motStamatCod = "",
    required this.motStastuCod,
    required this.normId,
    required this.notaBloccanteFlg,
    required this.passaggioFlg,
    required this.pdsCod,
    required this.pdsId,
    required this.profCod,
    required this.ptFlg,
    required this.staIscrCod,
    required this.staMatCod,
    required this.staStuCod,
    required this.stuId,
    //this.tipoCatAmmId = 0,
    required this.tipoCorsoCod,
    required this.tipoIscrCod,
    this.tipoSpecCod = "",
    required this.ultimoAnnoFlg,
  });

  factory DettaglioTratto.fromJson(Map<String, dynamic> json) =>
      DettaglioTratto(
        aaIscrId: json["aaIscrId"],
        aaOrdId: json["aaOrdId"],
        aaRegId: json["aaRegId"],
        anniFc: json["anniFC"],
        annoCorso: json["annoCorso"],
        cdsCod: json["cdsCod"],
        cdsId: json["cdsId"],
        condFlg: json["condFlg"],
        domiscrFlg: json["domiscrFlg"],
        durataAnni: json["durataAnni"],
        facCod: json["facCod"],
        facId: json["facId"],
        iscrId: json["iscrId"],
        matId: json["matId"],
        mobilFlg: json["mobilFlg"],
        motStaiscrCod: json["motStaiscrCod"],
        motStamatCod: json["motStamatCod"],
        motStastuCod: json["motStastuCod"],
        normId: json["normId"],
        notaBloccanteFlg: json["notaBloccanteFlg"],
        passaggioFlg: json["passaggioFlg"],
        pdsCod: json["pdsCod"],
        pdsId: json["pdsId"],
        profCod: json["profCod"],
        ptFlg: json["ptFlg"],
        staIscrCod: json["staIscrCod"],
        staMatCod: json["staMatCod"],
        staStuCod: json["staStuCod"],
        stuId: json["stuId"],
        //tipoCatAmmId: json["tipoCatAmmId"],
        tipoCorsoCod: json["tipoCorsoCod"],
        tipoIscrCod: json["tipoIscrCod"],
        tipoSpecCod: json["tipoSpecCod"],
        ultimoAnnoFlg: json["ultimoAnnoFlg"],
      );

  Map<String, dynamic> toJson() => {
        "aaIscrId": aaIscrId,
        "aaOrdId": aaOrdId,
        "aaRegId": aaRegId,
        "anniFC": anniFc,
        "annoCorso": annoCorso,
        "cdsCod": cdsCod,
        "cdsId": cdsId,
        "condFlg": condFlg,
        "domiscrFlg": domiscrFlg,
        "durataAnni": durataAnni,
        "facCod": facCod,
        "facId": facId,
        "iscrId": iscrId,
        "matId": matId,
        "mobilFlg": mobilFlg,
        "motStaiscrCod": motStaiscrCod,
        "motStamatCod": motStamatCod,
        "motStastuCod": motStastuCod,
        "normId": normId,
        "notaBloccanteFlg": notaBloccanteFlg,
        "passaggioFlg": passaggioFlg,
        "pdsCod": pdsCod,
        "pdsId": pdsId,
        "profCod": profCod,
        "ptFlg": ptFlg,
        "staIscrCod": staIscrCod,
        "staMatCod": staMatCod,
        "staStuCod": staStuCod,
        "stuId": stuId,
        //"tipoCatAmmId": tipoCatAmmId,
        "tipoCorsoCod": tipoCorsoCod,
        "tipoIscrCod": tipoIscrCod,
        "tipoSpecCod": tipoSpecCod,
        "ultimoAnnoFlg": ultimoAnnoFlg,
      };
}
*/