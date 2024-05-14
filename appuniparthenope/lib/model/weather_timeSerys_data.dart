import 'dart:convert';

class TimeSerysInfo {
  final String? result;
  final List<Timesery>? timeseries;

  TimeSerysInfo({
    this.result,
    this.timeseries,
  });

  factory TimeSerysInfo.fromRawJson(String str) =>
      TimeSerysInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TimeSerysInfo.fromJson(Map<String, dynamic> json) => TimeSerysInfo(
        result: json["result"],
        timeseries: json["timeseries"] == null
            ? []
            : List<Timesery>.from(
                json["timeseries"]!.map((x) => Timesery.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "timeseries": timeseries == null
            ? []
            : List<dynamic>.from(timeseries!.map((x) => x.toJson())),
      };
}

class Timesery {
  final double? clf;
  final double? crd;
  final double? crh;
  final String? dateTime;
  final double? dwd10;
  final double? dws10;
  final IDate? iDate;
  final Icon? icon;
  final String? link;
  final double? rh2;
  final double? rh300;
  final double? rh500;
  final double? rh700;
  final double? rh850;
  final double? rh925;
  final double? rh950;
  final double? rh975;
  final double? slp;
  final double? swe;
  final double? t2C;
  final double? tc300;
  final double? tc500;
  final double? tc700;
  final double? tc850;
  final double? tc925;
  final double? tc950;
  final double? tc975;
  final TextInfo? text;
  final double? u10M;
  final double? u300;
  final double? u500;
  final double? u700;
  final double? u850;
  final double? u925;
  final double? u950;
  final double? u975;
  final double? v10M;
  final double? v300;
  final double? v500;
  final double? v700;
  final double? v850;
  final double? v925;
  final double? v950;
  final double? v975;
  final double? wchill;
  final double? wd10;
  final String? winds;
  final double? ws10;
  final int? ws10B;
  final double? ws10K;
  final double? ws10N;

  Timesery({
    this.clf,
    this.crd,
    this.crh,
    this.dateTime,
    this.dwd10,
    this.dws10,
    this.iDate,
    this.icon,
    this.link,
    this.rh2,
    this.rh300,
    this.rh500,
    this.rh700,
    this.rh850,
    this.rh925,
    this.rh950,
    this.rh975,
    this.slp,
    this.swe,
    this.t2C,
    this.tc300,
    this.tc500,
    this.tc700,
    this.tc850,
    this.tc925,
    this.tc950,
    this.tc975,
    this.text,
    this.u10M,
    this.u300,
    this.u500,
    this.u700,
    this.u850,
    this.u925,
    this.u950,
    this.u975,
    this.v10M,
    this.v300,
    this.v500,
    this.v700,
    this.v850,
    this.v925,
    this.v950,
    this.v975,
    this.wchill,
    this.wd10,
    this.winds,
    this.ws10,
    this.ws10B,
    this.ws10K,
    this.ws10N,
  });

  factory Timesery.fromRawJson(String str) =>
      Timesery.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Timesery.fromJson(Map<String, dynamic> json) => Timesery(
        clf: json["clf"]?.toDouble(),
        crd: json["crd"]?.toDouble(),
        crh: json["crh"]?.toDouble(),
        dateTime: json["dateTime"],
        dwd10: json["dwd10"]?.toDouble(),
        dws10: json["dws10"]?.toDouble(),
        iDate: json["iDate"] == null ? null : iDateValues.map[json["iDate"]],
        icon: json["icon"] == null ? null : iconValues.map[json["icon"]],
        link: json["link"],
        rh2: json["rh2"]?.toDouble(),
        rh300: json["rh300"]?.toDouble(),
        rh500: json["rh500"]?.toDouble(),
        rh700: json["rh700"]?.toDouble(),
        rh850: json["rh850"]?.toDouble(),
        rh925: json["rh925"]?.toDouble(),
        rh950: json["rh950"]?.toDouble(),
        rh975: json["rh975"]?.toDouble(),
        slp: json["slp"]?.toDouble(),
        swe: json["swe"]?.toDouble(),
        t2C: json["t2c"]?.toDouble(),
        tc300: json["tc300"]?.toDouble(),
        tc500: json["tc500"]?.toDouble(),
        tc700: json["tc700"]?.toDouble(),
        tc850: json["tc850"]?.toDouble(),
        tc925: json["tc925"]?.toDouble(),
        tc950: json["tc950"]?.toDouble(),
        tc975: json["tc975"]?.toDouble(),
        text: json["text"] == null ? null : TextInfo.fromJson(json["text"]),
        u10M: json["u10m"]?.toDouble(),
        u300: json["u300"]?.toDouble(),
        u500: json["u500"]?.toDouble(),
        u700: json["u700"]?.toDouble(),
        u850: json["u850"]?.toDouble(),
        u925: json["u925"]?.toDouble(),
        u950: json["u950"]?.toDouble(),
        u975: json["u975"]?.toDouble(),
        v10M: json["v10m"]?.toDouble(),
        v300: json["v300"]?.toDouble(),
        v500: json["v500"]?.toDouble(),
        v700: json["v700"]?.toDouble(),
        v850: json["v850"]?.toDouble(),
        v925: json["v925"]?.toDouble(),
        v950: json["v950"]?.toDouble(),
        v975: json["v975"]?.toDouble(),
        wchill: json["wchill"]?.toDouble(),
        wd10: json["wd10"]?.toDouble(),
        winds: json["winds"],
        ws10: json["ws10"]?.toDouble(),
        ws10B: json["ws10b"]?.toInt(),
        ws10K: json["ws10k"]?.toDouble(),
        ws10N: json["ws10n"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "clf": clf,
        "crd": crd,
        "crh": crh,
        "dateTime": dateTime,
        "dwd10": dwd10,
        "dws10": dws10,
        "iDate": iDateValues.reverse[iDate],
        "icon": iconValues.reverse[icon],
        "link": link,
        "rh2": rh2,
        "rh300": rh300,
        "rh500": rh500,
        "rh700": rh700,
        "rh850": rh850,
        "rh925": rh925,
        "rh950": rh950,
        "rh975": rh975,
        "slp": slp,
        "swe": swe,
        "t2c": t2C,
        "tc300": tc300,
        "tc500": tc500,
        "tc700": tc700,
        "tc850": tc850,
        "tc925": tc925,
        "tc950": tc950,
        "tc975": tc975,
        "text": text?.toJson(),
        "u10m": u10M,
        "u300": u300,
        "u500": u500,
        "u700": u700,
        "u850": u850,
        "u925": u925,
        "u950": u950,
        "u975": u975,
        "v10m": v10M,
        "v300": v300,
        "v500": v500,
        "v700": v700,
        "v850": v850,
        "v925": v925,
        "v950": v950,
        "v975": v975,
        "wchill": wchill,
        "wd10": wd10,
        "winds": winds,
        "ws10": ws10,
        "ws10b": ws10B,
        "ws10k": ws10K,
        "ws10n": ws10N,
      };
}

enum IDate { THE_20240512_Z00 }

final iDateValues = EnumValues({"20240512Z00": IDate.THE_20240512_Z00});

enum Icon {
  CLOUDY1_NIGHT_PNG,
  CLOUDY1_PNG,
  CLOUDY2_NIGHT_PNG,
  CLOUDY2_PNG,
  CLOUDY4_NIGHT_PNG,
  CLOUDY4_PNG,
  CLOUDY5_NIGHT_PNG,
  CLOUDY5_PNG,
  SHOWER1_NIGHT_PNG,
  SUNNY_NIGHT_PNG,
  SUNNY_PNG
}

final iconValues = EnumValues({
  "cloudy1_night.png": Icon.CLOUDY1_NIGHT_PNG,
  "cloudy1.png": Icon.CLOUDY1_PNG,
  "cloudy2_night.png": Icon.CLOUDY2_NIGHT_PNG,
  "cloudy2.png": Icon.CLOUDY2_PNG,
  "cloudy4_night.png": Icon.CLOUDY4_NIGHT_PNG,
  "cloudy4.png": Icon.CLOUDY4_PNG,
  "cloudy5_night.png": Icon.CLOUDY5_NIGHT_PNG,
  "cloudy5.png": Icon.CLOUDY5_PNG,
  "shower1_night.png": Icon.SHOWER1_NIGHT_PNG,
  "sunny_night.png": Icon.SUNNY_NIGHT_PNG,
  "sunny.png": Icon.SUNNY_PNG
});

class TextInfo {
  final En? en;
  final It? it;

  TextInfo({
    this.en,
    this.it,
  });

  factory TextInfo.fromRawJson(String str) =>
      TextInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TextInfo.fromJson(Map<String, dynamic> json) => TextInfo(
        en: enValues.map[json["en"]]!,
        it: itValues.map[json["it"]]!,
      );

  Map<String, dynamic> toJson() => {
        "en": enValues.reverse[en],
        "it": itValues.reverse[it],
      };
}

enum En { CLEAR, CLOUDY, COVERED, PARTLY_CLOUDY, SHOWERS, VERY_CLOUDY }

final enValues = EnumValues({
  "Clear": En.CLEAR,
  "Cloudy": En.CLOUDY,
  "Covered": En.COVERED,
  "Partly Cloudy": En.PARTLY_CLOUDY,
  "Showers": En.SHOWERS,
  "Very Cloudy": En.VERY_CLOUDY
});

enum It { COPERTO, MOLTO_NUVOLOSO, NUVOLOSO, POCO_NUVOLOSO, ROVESCI, SERENO }

final itValues = EnumValues({
  "Coperto": It.COPERTO,
  "Molto nuvoloso": It.MOLTO_NUVOLOSO,
  "Nuvoloso": It.NUVOLOSO,
  "Poco nuvoloso": It.POCO_NUVOLOSO,
  "Rovesci": It.ROVESCI,
  "Sereno": It.SERENO
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
