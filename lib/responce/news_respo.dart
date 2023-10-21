import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:news_app/models/news_model/news_data_model.dart';

import '../api_exception/exception.dart';
class News{
Future<dynamic> getApi(String url) async {
  try{
    final res= await http.get(Uri.parse(url));
    return apiResponse(res);
  }on SocketException{
   throw FetchDataException(mBody: 'Internet Error');
  }
}
dynamic apiResponse(http.Response res){
  switch(res.statusCode){
    case 200: var mResData=jsonDecode(res.body);
    return NewsModel.fromJson(mResData);
    case 400:throw BadRequestException(mBody: res.body);
    case 401:
    case 403:
    case 407:throw UnAuthorisedException(mBody: res.body);
    case 500:
    default: throw ServerException(mBody: res.body);
  }
}
}
