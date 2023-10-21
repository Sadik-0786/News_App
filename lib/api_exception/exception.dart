class ApiException implements Exception{
  String title;
  String body;
  ApiException({required this.title,required this.body});
  String toFormattedError(){
    return '$title : $body';
  }
}
class FetchDataException extends ApiException{
  FetchDataException({required String mBody}):super(title:'Data Loading Exception',body: mBody);
}
class UnAuthorisedException extends ApiException{
  UnAuthorisedException({required String mBody}):super(title: 'UnAuthorised Access Exception',body:mBody );
}
class InValidInputException extends ApiException{
  InValidInputException({required String mBody}):super(title: 'InValid InPut Exception' ,body:mBody );
}
class ServerException extends ApiException{
  ServerException({required String mBody}):super(title: 'Server Exception',body:mBody);
}
class BadRequestException extends ApiException{
  BadRequestException({required String mBody}):super(title: 'Server Exception',body:mBody);
}