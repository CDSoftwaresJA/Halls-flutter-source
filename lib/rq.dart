import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hallandroidsource/dialogs.dart';
import 'package:hallandroidsource/toasts.dart';
//import 'package:http/http.dart';



class RequestBuilder {
  BuildContext context;
  RequestBuilder(this.context);

  makeGetRequest(String url)   {
//    // make GET request
//    Response response =  get(url); // sample info available in response
//    int statusCode = response.statusCode;
//    Map<String, String> headers = response.headers;
//    String contentType = headers['content-type'];
//    var body = json.decode(response.body);
//    body = body['items'];
//    Dialogs dialogs = new Dialogs(context);
//
//    dialogs.ShowD("JSON GET", getPrettyJSONString(body));
//    print(getPrettyJSONString(response.body));
  }

  makePostRequest(String url, String jsonFile)  {
//    Map<String, String> headers = {"Content-type": "application/json"};
//    Response response = await post(url,
//        headers: headers,
//        body: jsonFile); // check the status code for the result
//    int statusCode = response
//        .statusCode; // this API passes back the id of the new item added to the body
//    showToast(response.body);
//    return response.body;
  }

  formatJson(String jsonString) {
//    var body = json.decode(jsonString);
//    body = body['items'];
//    return body;
  }

  String getPrettyJSONString(jsonObject) {
//    var encoder = new JsonEncoder.withIndent("     ");
//    return encoder.convert(jsonObject);
  }
}