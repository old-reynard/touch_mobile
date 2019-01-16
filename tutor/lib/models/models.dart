import 'package:meta/meta.dart';
import 'package:tutor/data/constants.dart';

class User {
  int id;
  String username;
  String firstName;
  String lastName;
  String email;
  String password;
  bool active;
  bool staff;
  bool admin;
  DateTime createdAt;
  bool confirmed;
  DateTime confirmedAt;
  double latitude;
  double longitude;
  String position;
  String biography;
  bool finder;
  List<Specialty> specialties;

  User({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.active = true,
    this.staff = false,
    this.admin = false,
    this.createdAt,
    this.confirmed,
    this.confirmedAt,
    this.latitude,
    this.longitude,
    this.position,
    this.biography,
    this.finder = true,
    this.specialties,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json[idKey],
      active: json[activeKey] ?? true,
      staff: json[staffKey] ?? false,
      admin: json[adminKey] ?? false,
      createdAt: DateTime.parse(json[createdAtKey]) ?? null,
      confirmed: json[confirmedKey] ?? false,
      confirmedAt: json[confirmedAtKey],
      latitude: json[latitudeKey] ?? 0,
      longitude: json[longitudeKey] ?? 0,
      position: json[positionKey] ?? '',
      biography: json[biographyKey] ?? '',
      finder: json[finderKey] ?? true,
      email: json[emailKey],
      firstName: json[firstNameKey],
      lastName: json[lastNameKey],
      password: json[passwordKey],
      username: json[usernameKey],
    );
  }

  @override
  String toString() => '${this.firstName} ${this.lastName}';

  @override
  bool operator ==(other) {
    if (!(other is User)) return false;
    return this.email == (other as User).email &&
        this.username == (other as User).username;
  }
}

class Specialty {
  final String name;
  final String description;

  Specialty(@required this.name, {this.description})
      : assert(name != null),
        assert(name.isNotEmpty);

  @override
  String toString() => this.name;
}
