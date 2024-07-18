import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse(
    {required http.Response response,
    required BuildContext context,
    required VoidCallback onSuccess}) {
  //stwich statement to handle different http status code
  switch (response.statusCode) {
    case 200: //status code 200 indicates a successfull request
      onSuccess();
      break;
    case 400: //statuse code 400 indicates a bad request
      showSnackBar(context, json.decode(response.body)['msg']);
      break;
    case 500: //stutus code 500 indicates internal server error
      showSnackBar(context, json.decode(response.body)['error']);
      break;
    case 201: //statuse code indicates a resource has been created successfully
      onSuccess();
      break;
  }
}

void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}
