import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseurl =
      "http://185.196.214.63:3000"; //https://tso202109.herokuapp.com/
  var log = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future<http.Response> signIn(String url, Map<String, String> body) async {
    var url = "http://185.196.214.63:3000/api/user/login";
    log.d(body);
    print(Uri.parse(url));

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> verifyUser(String url, String token) async {
    url = formater(url);
    log.d(token);

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
    );

    return response;
  }

  Future<http.Response> getUserByToken(String url, String token) async {
    url = formater(url);
    log.d(token);
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
    );
    return response;
  }

  Future<http.Response> updateUser(
      String url, String token, Map<String, String> body) async {
    url = formater(url);

    log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> getAllUser(
    String url,
    String token,
  ) async {
    url = formater(url);

    log.d(token);
    var response = await http.get(Uri.parse(url), headers: {
      'Access-Control-Allow-Origin': '*',
      'Content-type': 'application/json',
      "Authorization": token,
    });
    return response;
  }

  Future<http.Response> registerUser(
      String url, String token, Map<String, String> body) async {
    url = formater(url);

    log.d(body);
    var response = await http.post(
      Uri.http("$baseurl", "$url"),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> deleteUser(
      String url, String token, Map<String, String> body) async {
    url = formater(url);

    log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> getAllSensor(String url, String token) async {
    url = formater(url);
    log.d(token);
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
    );
    return response;
  }

  Future<http.Response> updateSensor(
      String url, String token, Map<String, String> body) async {
    url = formater(url);

    log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> getTabelBySensor(
      String url, String token, Map<String, String> body) async {
    // url = formater(url);
    log.d(token);
    var uri = Uri.http("185.196.214.63:3000", url, body);
    var response = await http.get(
      uri,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
    );
    return response;
  }

  Future<http.Response> ddd(
      String url, String token, Map<String, String> body) async {
    url = formater(url);

    log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> getDataTodayID(
      String url, String token, Map<String, String> body) async {
    // url = formater(url);
    log.d(body);
    var uri = Uri.http("185.196.214.63:3000", url, body);
    var response = await http.get(
      uri,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
    );
    return response;
  }

  Future<http.Response> updateTabelById(
      String url, String token, Map<String, String> body) async {
    url = formater(url);

    log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> saveTabelById(
      String url, String token, Map<String, String> body) async {
    url = formater(url);

    log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> deleteTabelById(
      String url, String token, Map<String, String> body) async {
    url = formater(url);

    log.d(body);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> gatOnline(String url, String token) async {
    url = formater(url);
    log.d(token);
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
    );
    return response;
  }

  Future<http.Response> getlastWeekData(String url, String token) async {
    url = formater(url);
    log.d(token);
    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Content-type': 'application/json',
        "Authorization": token,
      },
    );
    return response;
  }

  String formater(String url) {
    return baseurl + url;
  }
}
