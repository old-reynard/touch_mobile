import 'dart:async';
import 'package:tutor/models/models.dart';


class ProfileService {

  Future<User> getUser() async {
    return User(
      firstName: 'Kit',
      lastName: 'Grissom',
      email: 'grissomkit@gmail.com',
      active: true,
      admin: true,
      staff: true,
      createdAt: DateTime(2018, 12, 30),
      confirmed: true,
      position: 'Flutter developer at KK',
      biography: 'Involved, responsible, attentive Java / Android / Flutter programmer with linguistic background and passion for all things mathematical (and proven track of programming skills - I have published both native and Flutter apps for Android). I see programming as the perfect mix and purest practical application of my two biggest loves – languages and math. Hence, my utter fascination with computer science and software development that makes me want to spend my time building new apps and learning new concepts.',
      finder: true,
      latitude: 43.670560,
      longitude: -79.373990,
      specialties: [Specialty('English As a Second Language and English Literacy Development'), Specialty('Mathematics'), Specialty('French As a Second Language'), Specialty('Computer Studies'), Specialty('Canadian and World Studies'),],
    );
  }
}