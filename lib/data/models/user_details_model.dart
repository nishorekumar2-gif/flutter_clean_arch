class UserDetailsModel {
  final List<User>? users;
  final int? total;
  final int? skip;
  final int? limit;

  UserDetailsModel({this.users, this.total, this.skip, this.limit});

  UserDetailsModel copyWith({
    List<User>? users,
    int? total,
    int? skip,
    int? limit,
  }) => UserDetailsModel(
    users: users ?? this.users,
    total: total ?? this.total,
    skip: skip ?? this.skip,
    limit: limit ?? this.limit,
  );
}

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? maidenName;
  final int? age;
  final Gender? gender;
  final String? email;
  final String? phone;
  final String? username;
  final String? password;
  final String? birthDate;
  final String? image;
  final String? bloodGroup;
  final double? height;
  final double? weight;
  final String? eyeColor;
  final Hair? hair;
  final String? ip;
  final Address? address;
  final String? macAddress;
  final String? university;
  final Bank? bank;
  final Company? company;
  final String? ein;
  final String? ssn;
  final String? userAgent;
  final Crypto? crypto;
  final Role? role;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.maidenName,
    this.age,
    this.gender,
    this.email,
    this.phone,
    this.username,
    this.password,
    this.birthDate,
    this.image,
    this.bloodGroup,
    this.height,
    this.weight,
    this.eyeColor,
    this.hair,
    this.ip,
    this.address,
    this.macAddress,
    this.university,
    this.bank,
    this.company,
    this.ein,
    this.ssn,
    this.userAgent,
    this.crypto,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      image: json['image']?.toString(),
      email: json['email']?.toString() ?? '',
      gender: switch (json['gender']?.toString().toLowerCase()) {
        'female' => Gender.FEMALE,
        'male' => Gender.MALE,
        _ => null,
      },
    );
  }

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? maidenName,
    int? age,
    Gender? gender,
    String? email,
    String? phone,
    String? username,
    String? password,
    String? birthDate,
    String? image,
    String? bloodGroup,
    double? height,
    double? weight,
    String? eyeColor,
    Hair? hair,
    String? ip,
    Address? address,
    String? macAddress,
    String? university,
    Bank? bank,
    Company? company,
    String? ein,
    String? ssn,
    String? userAgent,
    Crypto? crypto,
    Role? role,
  }) => User(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    maidenName: maidenName ?? this.maidenName,
    age: age ?? this.age,
    gender: gender ?? this.gender,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    username: username ?? this.username,
    password: password ?? this.password,
    birthDate: birthDate ?? this.birthDate,
    image: image ?? this.image,
    bloodGroup: bloodGroup ?? this.bloodGroup,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    eyeColor: eyeColor ?? this.eyeColor,
    hair: hair ?? this.hair,
    ip: ip ?? this.ip,
    address: address ?? this.address,
    macAddress: macAddress ?? this.macAddress,
    university: university ?? this.university,
    bank: bank ?? this.bank,
    company: company ?? this.company,
    ein: ein ?? this.ein,
    ssn: ssn ?? this.ssn,
    userAgent: userAgent ?? this.userAgent,
    crypto: crypto ?? this.crypto,
    role: role ?? this.role,
  );
}

class Address {
  final String? address;
  final String? city;
  final String? state;
  final String? stateCode;
  final String? postalCode;
  final Coordinates? coordinates;
  final Country? country;

  Address({
    this.address,
    this.city,
    this.state,
    this.stateCode,
    this.postalCode,
    this.coordinates,
    this.country,
  });

  Address copyWith({
    String? address,
    String? city,
    String? state,
    String? stateCode,
    String? postalCode,
    Coordinates? coordinates,
    Country? country,
  }) => Address(
    address: address ?? this.address,
    city: city ?? this.city,
    state: state ?? this.state,
    stateCode: stateCode ?? this.stateCode,
    postalCode: postalCode ?? this.postalCode,
    coordinates: coordinates ?? this.coordinates,
    country: country ?? this.country,
  );
}

class Coordinates {
  final double? lat;
  final double? lng;

  Coordinates({this.lat, this.lng});

  Coordinates copyWith({double? lat, double? lng}) =>
      Coordinates(lat: lat ?? this.lat, lng: lng ?? this.lng);
}

enum Country { UNITED_STATES }

class Bank {
  final String? cardExpire;
  final String? cardNumber;
  final String? cardType;
  final String? currency;
  final String? iban;

  Bank({
    this.cardExpire,
    this.cardNumber,
    this.cardType,
    this.currency,
    this.iban,
  });

  Bank copyWith({
    String? cardExpire,
    String? cardNumber,
    String? cardType,
    String? currency,
    String? iban,
  }) => Bank(
    cardExpire: cardExpire ?? this.cardExpire,
    cardNumber: cardNumber ?? this.cardNumber,
    cardType: cardType ?? this.cardType,
    currency: currency ?? this.currency,
    iban: iban ?? this.iban,
  );
}

class Company {
  final String? department;
  final String? name;
  final String? title;
  final Address? address;

  Company({this.department, this.name, this.title, this.address});

  Company copyWith({
    String? department,
    String? name,
    String? title,
    Address? address,
  }) => Company(
    department: department ?? this.department,
    name: name ?? this.name,
    title: title ?? this.title,
    address: address ?? this.address,
  );
}

class Crypto {
  final Coin? coin;
  final Wallet? wallet;
  final Network? network;

  Crypto({this.coin, this.wallet, this.network});

  Crypto copyWith({Coin? coin, Wallet? wallet, Network? network}) => Crypto(
    coin: coin ?? this.coin,
    wallet: wallet ?? this.wallet,
    network: network ?? this.network,
  );
}

enum Coin { BITCOIN }

enum Network { ETHEREUM_ERC20 }

enum Wallet { THE_0_XB9_FC2_FE63_B2_A6_C003_F1_C324_C3_BFA53259162181_A }

enum Gender { FEMALE, MALE }

class Hair {
  final String? color;
  final Type? type;

  Hair({this.color, this.type});

  Hair copyWith({String? color, Type? type}) =>
      Hair(color: color ?? this.color, type: type ?? this.type);
}

enum Type { CURLY, KINKY, STRAIGHT, WAVY }

enum Role { ADMIN, MODERATOR, USER }
