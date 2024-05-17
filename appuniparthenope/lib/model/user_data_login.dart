import 'dart:convert';

class UserInfo {
  final String authToken;
  final User user;
  final TrattiCarriera selectedCareer;

  UserInfo({
    required this.authToken,
    required this.user,
    required this.selectedCareer,
  });

  factory UserInfo.fromRawJson(String str) =>
      UserInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        authToken: json["authToken"],
        user: User.fromJson(json["user"]),
        selectedCareer: TrattiCarriera.fromJson(json["selectedCareer"]),
      );

  Map<String, dynamic> toJson() => {
        "authToken": authToken,
        "user": user.toJson(),
        "selectedCareer": selectedCareer.toJson(),
      };
}

class User {
  final String aliasName;
  final String codFis;
  final dynamic docenteId;
  final String firstName;
  final String grpDes;
  final int grpId;
  final int id;
  final dynamic idAb;
  final String lastName;
  final int persId;
  final int sessionTimeout;
  final String sex;
  final dynamic soggEstId;
  final int tipoFirmaFaId;
  final int tipoFirmaId;
  final List<TrattiCarriera> trattiCarriera;
  final String userId;

  User({
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
    required this.userId,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        aliasName: json["aliasName"],
        codFis: json["codFis"],
        docenteId: json["docenteId"],
        firstName: json["firstName"],
        grpDes: json["grpDes"],
        grpId: json["grpId"],
        id: json["id"],
        idAb: json["idAb"],
        lastName: json["lastName"],
        persId: json["persId"],
        sessionTimeout: json["sessionTimeout"],
        sex: json["sex"],
        soggEstId: json["soggEstId"],
        tipoFirmaFaId: json["tipoFirmaFaId"],
        tipoFirmaId: json["tipoFirmaId"],
        trattiCarriera: List<TrattiCarriera>.from(
            json["trattiCarriera"].map((x) => TrattiCarriera.fromJson(x))),
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "aliasName": aliasName,
        "codFis": codFis,
        "docenteId": docenteId,
        "firstName": firstName,
        "grpDes": grpDes,
        "grpId": grpId,
        "id": id,
        "idAb": idAb,
        "lastName": lastName,
        "persId": persId,
        "sessionTimeout": sessionTimeout,
        "sex": sex,
        "soggEstId": soggEstId,
        "tipoFirmaFaId": tipoFirmaFaId,
        "tipoFirmaId": tipoFirmaId,
        "trattiCarriera":
            List<dynamic>.from(trattiCarriera.map((x) => x.toJson())),
        "userId": userId,
      };
}

class TrattiCarriera {
  final String cdsDes;
  final int cdsId;
  final DettaglioTratto dettaglioTratto;
  final int matId;
  final String matricola;
  final String motStastuCod;
  final String motStastuDes;
  final String staMatCod;
  final String staMatDes;
  final String staStuCod;
  final String staStuDes;
  final int stuId;
  final String strutturaDes;
  final String strutturaId;
  final String strutturaGaId;
  final String corsoGaId;

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
    required this.strutturaDes,
    required this.strutturaId,
    required this.strutturaGaId,
    required this.corsoGaId,
  });

  factory TrattiCarriera.fromRawJson(String str) =>
      TrattiCarriera.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TrattiCarriera.fromJson(Map<String, dynamic> json) => TrattiCarriera(
        cdsDes: json["cdsDes"],
        cdsId: json["cdsId"],
        dettaglioTratto: DettaglioTratto.fromJson(json["dettaglioTratto"]),
        matId: json["matId"],
        matricola: json["matricola"],
        motStastuCod: json["motStastuCod"],
        motStastuDes: json["motStastuDes"],
        staMatCod: json["staMatCod"],
        staMatDes: json["staMatDes"],
        staStuCod: json["staStuCod"],
        staStuDes: json["staStuDes"],
        stuId: json["stuId"],
        strutturaDes: json["strutturaDes"],
        strutturaId: json["strutturaId"],
        strutturaGaId: json["strutturaGaId"],
        corsoGaId: json["corsoGaId"],
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
  final int aaIscrId;
  final int aaOrdId;
  final int aaRegId;
  final int anniFc;
  final int annoCorso;
  final String cdsCod;
  final int cdsId;
  final int condFlg;
  final int domiscrFlg;
  final int durataAnni;
  final String facCod;
  final int facId;
  final int iscrId;
  final int matId;
  final int mobilFlg;
  final String motStaiscrCod;
  final String motStamatCod;
  final String motStastuCod;
  final int normId;
  final int notaBloccanteFlg;
  final int passaggioFlg;
  final String pdsCod;
  final int pdsId;
  final String profCod;
  final int ptFlg;
  final String staIscrCod;
  final String staMatCod;
  final String staStuCod;
  final int stuId;
  final dynamic tipoCatAmmId;
  final String tipoCorsoCod;
  final String tipoIscrCod;
  final String tipoSpecCod;
  final int ultimoAnnoFlg;

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

  factory DettaglioTratto.fromRawJson(String str) =>
      DettaglioTratto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
        tipoCatAmmId: json["tipoCatAmmId"],
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
        "tipoCatAmmId": tipoCatAmmId,
        "tipoCorsoCod": tipoCorsoCod,
        "tipoIscrCod": tipoIscrCod,
        "tipoSpecCod": tipoSpecCod,
        "ultimoAnnoFlg": ultimoAnnoFlg,
      };
}
