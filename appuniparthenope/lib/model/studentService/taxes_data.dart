import 'dart:convert';

class TaxesInfo {
  final String semaforo;
  final List<Payed> payed;
  final List<ToPay> toPay;

  TaxesInfo({
    required this.semaforo,
    required this.payed,
    required this.toPay,
  });

  factory TaxesInfo.fromRawJson(String str) =>
      TaxesInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaxesInfo.fromJson(Map<String, dynamic> json) => TaxesInfo(
        semaforo: json["semaforo"],
        payed: List<Payed>.from(json["payed"].map((x) => Payed.fromJson(x))),
        toPay: List<ToPay>.from(json["to_pay"].map((x) => ToPay.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "semaforo": semaforo,
        "payed": List<dynamic>.from(payed.map((x) => x.toJson())),
        "to_pay": List<dynamic>.from(toPay.map((x) => x.toJson())),
      };
}

class Payed {
  final String desc;
  final int fattId;
  final String importo;
  final String dataPagamento;
  final String scadFattura;
  final String? iur;
  final String? nBollettino;

  Payed({
    required this.desc,
    required this.fattId,
    required this.importo,
    required this.dataPagamento,
    required this.scadFattura,
    required this.iur,
    required this.nBollettino,
  });

  factory Payed.fromRawJson(String str) => Payed.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Payed.fromJson(Map<String, dynamic> json) => Payed(
        desc: json["desc"],
        fattId: json["fattId"],
        importo: json["importo"],
        dataPagamento: json["dataPagamento"],
        scadFattura: json["scadFattura"],
        iur: json["iur"],
        nBollettino: json["nBollettino"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "fattId": fattId,
        "importo": importo,
        "dataPagamento": dataPagamento,
        "scadFattura": scadFattura,
        "iur": iur,
        "nBollettino": nBollettino,
      };
}

class ToPay {
  final String desc;
  final int fattId;
  final String importo;
  final String iuv;
  final String scadFattura;

  ToPay({
    required this.desc,
    required this.fattId,
    required this.importo,
    required this.iuv,
    required this.scadFattura,
  });

  factory ToPay.fromRawJson(String str) => ToPay.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ToPay.fromJson(Map<String, dynamic> json) => ToPay(
        desc: json["desc"],
        fattId: json["fattId"],
        importo: json["importo"],
        iuv: json["iuv"],
        scadFattura: json["scadFattura"],
      );

  Map<String, dynamic> toJson() => {
        "desc": desc,
        "fattId": fattId,
        "importo": importo,
        "iuv": iuv,
        "scadFattura": scadFattura,
      };
}
