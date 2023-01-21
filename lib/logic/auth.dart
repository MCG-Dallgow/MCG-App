import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mcgapp/classes/user.dart';
import 'package:mcgapp/enums/group.dart';

import '../main.dart';

class Auth {
  static final dio = Dio();

  static Future<String> signup(String username, String encryptedPassword) async {
    try {
      var response = await dio.post(
        '$apiBaseURL/auth/signup',
        options: Options(headers: {
          'username': username,
          'encrypted_password': encryptedPassword,
        }),
      );
      var data = response.data;
      if (kDebugMode) print(data);

      return 'success';
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 403: return 'invalid credentials';
        case 409: return 'user exists';
        default: return 'error';
      }
    }
  }

  static Future<String> login(String username, String encryptedPassword) async {
    try {
      var response = await dio.post(
        '$apiBaseURL/auth/login',
        options: Options(headers: {
          'username': username,
          'encrypted_password': encryptedPassword,
        }),
      );
      var data = response.data;
      if (kDebugMode) print(data);

      AppUser user = AppUser(
        username: username,
        password: encryptedPassword,
        firstname: data['firstname'],
        lastname: data['lastname'],
        group: Group.fromName(data['group'])!,
      );

      AppUser.saveUser(user);

      return 'success';
    } on DioError catch (e) {
      switch (e.response?.statusCode) {
        case 403: return 'invalid credentials';
        case 404: return 'user does not exist';
        default: return 'error';
      }
    }
  }
}
