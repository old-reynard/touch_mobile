import 'package:http/http.dart' as http;
import 'package:tutor/data/constants.dart';
import 'package:tutor/models/models.dart';
import 'dart:convert';

const createUserApi =  baseApiUrl + 'create_user/create/';
const verifyUsernameApi = baseApiUrl + 'username/unique/';

class CreateUserService {
  var client = http.Client();

  Future<String> createUser(User user) async {
    Map userData = {
      usernameKey:  user.username,
      passwordKey:  user.password,
      firstNameKey: user.firstName,
      lastNameKey:  user.lastName,
      emailKey:     user.email
    };
    
    var response = await client.post(
        createUserApi,
        body: json.encode(userData),
        headers: jsonHeader
        );
    print(response.body);
    return response.body;
  }

  Future<String> verifyUsername(String username) async {
    Map userData = {usernameKey: username,};
    var response = await client.post(
      verifyUsernameApi,
      body: json.encode(userData),
      headers: jsonHeader
    );
    print(response.body);
    return response.body;
  }
}