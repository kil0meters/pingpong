import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<http.Response> serverRequest(BuildContext context, String serverUrl, String apiRequest) async {
  http.Response response;
  if (serverUrl != ':5858') {
    try {
      response = await http.get(Uri.http(serverUrl, apiRequest));
    } catch (error) {
      print('Error making request to $serverUrl$apiRequest: $error');
      Scaffold.of(context).showSnackBar(
        errorSnackBar('Could not find server'),
      );
    }
  }
  return response;
}

SnackBar errorSnackBar(String message) {
  return SnackBar(
    content: Text(
      'ERROR: $message',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'DISMISS',
      textColor: Colors.green,
      onPressed: () {},
    ),
  );
}