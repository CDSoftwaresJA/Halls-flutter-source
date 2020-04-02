import 'package:flutter/material.dart';
import 'dart:convert';
import 'file:///G:/Flutter%20Projects/hal_src_march_23/lib/objects/song.dart';
import 'file:///G:/Flutter%20Projects/hal_src_march_23/lib/utils/toasts.dart';
import 'package:http/http.dart';

class RequestBuilder {
  BuildContext context;
  RequestBuilder(this.context);

  Response response;
  makeGetRequest(String url) async {
    // make GET request
    Response response = await get(url); // sample info available in response
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    var body = json.decode(response.body);
    body = body['items'];

    return body;
    //dialogs.ShowD("JSON GET", getPrettyJSONString(body));
    //print(getPrettyJSONString(response.body));
  }

  makePostRequest(String url, String jsonFile) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post(url,
        headers: headers,
        body: jsonFile); // check the status code for the result
    int statusCode = response
        .statusCode; // this API passes back the id of the new item added to the body
    //showToast(response.body);

    //var body = json.decode(response.body);
    //body = body['items'];
    print(response.body);
  }

  uploadFile(String url, String path, String query) async {
    final postUri = Uri.parse(url);
    MultipartRequest request = MultipartRequest('POST', postUri);

    MultipartFile multipartFile = await MultipartFile.fromPath(
        query, path); //returns a Future<MultipartFile>

    request.files.add(multipartFile);

    StreamedResponse response = await request.send();
  }

  formatJson(String jsonString) {
    var body = json.decode(jsonString);
    body = body['items'];
    return body;
  }

  String getPrettyJSONString(jsonObject) {
    var encoder = new JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }
}
