class UserDetails {
  final String nome;
  final String cognome;
  final String codFis;
  final String dataNascita;
  final String desCittadinanza;
  final String email;
  final String emailAte;
  final String sesso;
  final String telRes;

  UserDetails({
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

  factory UserDetails.fromJson(Map<String, dynamic> userDetailsJson) {
    return UserDetails(
      nome: userDetailsJson['nome'],
      cognome: userDetailsJson['cognome'],
      codFis: userDetailsJson['codFis'],
      dataNascita: userDetailsJson['dataNascita'],
      desCittadinanza: userDetailsJson['desCittadinanza'],
      email: userDetailsJson['email'],
      emailAte: userDetailsJson['emailAte'],
      sesso: userDetailsJson['sesso'],
      telRes: userDetailsJson['telRes'],
    );
  }
}