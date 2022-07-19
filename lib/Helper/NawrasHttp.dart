import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> postHTTP(
    {String url, Map<String, dynamic> body}) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Auth': '123456'
  };
  final bodyJson = jsonEncode(
    body,
  );
  var response = await http.post(
    url,
    headers: headers,
    body: bodyJson,
  );

  // print("For URL:: $url Response is ::::::" + response.statusCode.toString());
  // print('response.body ${response.body}');

  bool isPass =  handleError(jsonDecode(response.body)["code"].toString());

  if (isPass) {
    return jsonDecode(response.body);
  } else {
    print(response);
    return null;
  }
}
//
// Future<String> nawrasGetHTTP({String url, Map<String, String> body}) async {
//   Map<String, String> headers = {
//     'Content-Type': 'application/json',
//     'Auth': '123456'
//   };
//   final bodyJson = jsonEncode(
//     body,
//   );
//   var response = await http.get(url, headers: headers);
//   // print("For URL:: $url Response is ::::::" + response.statusCode.toString());
//
//   bool isPass = handleError(jsonDecode(response.body)["code"].toString());
//
//   if (isPass) {
//     return response.body;
//   } else {
//     return "null";
//   }
// }

bool handleError(String code)  {
  if (code == "200") {
    print("STATUS CODE IS:: SUCCESS");
    return true;
  } else if (code == "401") {
    print("STATUS CODE IS:: ERROR AUTHENTICATION");
    return false;
  } else if (code == "402") {
    print("STATUS CODE IS:: ERROR JSON FORMAT");
    return false;
  } else if (code == "403") {
    print("STATUS CODE IS:: ERROR HEADER INFO");
    return false;
  } else if (code == "404") {
    print("STATUS CODE IS:: TOKEN EXPIRED");
    // handle update token Use Await....
    return false;
  } else if (code == "440") {
    print("STATUS CODE IS:: UNKNOWN");
    return false;
  } else {
    return false;
  }
}
