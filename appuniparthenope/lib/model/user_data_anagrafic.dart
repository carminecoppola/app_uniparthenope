class UserAnagrafe {
  final String? nome;
  final String? cognome;
  final String? codFis;
  final String? dataNascita;
  final String? desCittadinanza;
  final String? email;
  final String? emailAte;
  final String? sesso;
  final String? telRes;

  UserAnagrafe({
    this.nome,
    this.cognome,
    this.codFis,
    this.dataNascita,
    this.desCittadinanza,
    this.email,
    this.emailAte,
    this.sesso,
    this.telRes,
  });

  factory UserAnagrafe.fromJson(Map<String, dynamic> json) {
    return UserAnagrafe(
      nome: json['nome'] ?? '',
      cognome: json['cognome'] ?? '',
      codFis: json['codFis'] ?? '',
      dataNascita: json['dataNascita'] ?? '',
      desCittadinanza: json['desCittadinanza'] ?? '',
      email: json['email'] ?? '',
      emailAte: json['emailAte'] ?? '',
      sesso: json['sesso'] ?? '',
      telRes: json['telRes'] ?? '',
    );
  }
}
