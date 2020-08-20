import 'dart:convert';

import 'package:blocform/src/shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  static final String _apiKey = 'AIzaSyCg26XDs0rGFnj6wx7qF4iOilKjinFUlMI';
  final signinurl = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey';
  final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey';

  final _prefs = new Preferences();


  Future newUser(String email, String password) async {
    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final res = await http.post(
      url,
      body: json.encode(authData));

      Map<String, dynamic> decodedData = json.decode(res.body);
      //print(decodedData);
      if(decodedData.containsKey('idToken')) {
        _prefs.token = decodedData['idToken'];
        return {'ok': true, 'token': decodedData['idToken']};
      } else {
        return {'ok': false, 'message': decodedData['error']['message']};

      }
  }

  Future<Map<String, dynamic>> login (String email, String password) async {
    final authData = {
      'email' : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final res = await http.post(
      signinurl,
      body: json.encode(authData));

      Map<String, dynamic> decodedData = json.decode(res.body);
      print(decodedData);
      if(decodedData.containsKey('idToken')) {
        _prefs.token = decodedData['idToken'];
        return {'ok': true, 'token': decodedData['idToken']};
      } else {
        return {'ok': false, 'message': decodedData['error']['message']};

      }
  }
}