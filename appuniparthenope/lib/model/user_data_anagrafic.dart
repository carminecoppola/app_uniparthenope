class UserAnagrafe {
  final String nome;
  final String cognome;
  final String codFis;
  final String dataNascita;
  final String desCittadinanza;
  final String email;
  final String emailAte;
  final String sesso;
  final String telRes;

  UserAnagrafe({
    required this.nome,
    required this.cognome,
    required this.codFis,
    required this.dataNascita,
    required this.desCittadinanza,
    required this.email,
    required this.emailAte,
    required this.sesso,
    required this.telRes,
  });

  factory UserAnagrafe.fromJson(Map<String, dynamic> UserAnagrafeJson) {
    return UserAnagrafe(
      nome: UserAnagrafeJson['nome'],
      cognome: UserAnagrafeJson['cognome'],
      codFis: UserAnagrafeJson['codFis'],
      dataNascita: UserAnagrafeJson['dataNascita'],
      desCittadinanza: UserAnagrafeJson['desCittadinanza'],
      email: UserAnagrafeJson['email'],
      emailAte: UserAnagrafeJson['emailAte'],
      sesso: UserAnagrafeJson['sesso'],
      telRes: UserAnagrafeJson['telRes'],
    );
  }
}