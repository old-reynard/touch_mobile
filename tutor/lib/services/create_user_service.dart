import 'package:http/http.dart' as http;
import 'package:tutor/data/constants.dart';
import 'package:tutor/models/models.dart';
import 'dart:convert';

const createUserApi     = baseApiUrl + 'create_user/create/';
const verifyUsernameApi = baseApiUrl + 'username/unique/';
const verifyEmailApi    = baseApiUrl + 'email/unique/';
const getApiKeyApi      = baseApiUrl + 'keys/ak/';

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

  Future<String> verifyUnique(String verifiable, String type) async {
    Map userData;
    String api;
    switch(type) {
      case emailKey:
        userData = {emailKey: verifiable,};
        api = verifyEmailApi;
        break;
      case usernameKey:
        userData = {usernameKey: verifiable,};
        api = verifyUsernameApi;
        break;
      default:
        userData = null;
        api = null;
    }

    if (api == null) return null;
    var response = await client.post(
      api, body: json.encode(userData), headers: jsonHeader
    );
    print(response.body);
    return response.body;
  }

  Future<String> getApiKey(int id) async {
    Map userData = {
      userIdKey: id,
    };

    var response = await client.post(getApiKeyApi,
      headers: jsonHeader, body: jsonEncode(userData)
    );
    print(response.body);
    return response.body;
  }

}