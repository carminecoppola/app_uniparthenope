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
  //final List<TrattoCarriera> trattiCarriera; //Da vedere

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
    //required this.trattiCarriera,
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
      // trattiCarriera: List<TrattoCarriera>.from(userJson['user']
      //         ['trattiCarriera']
      //     .map((tratto) => TrattoCarriera.fromJson(tratto))),
    );
  }

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, username: $username, password: $password, role: $role, persId: $persId, authToken: $authToken, aliasName: $aliasName, codFis: $codFis}';
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
