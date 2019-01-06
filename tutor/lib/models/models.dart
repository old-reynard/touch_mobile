class User {
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

  User({
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
  });
}