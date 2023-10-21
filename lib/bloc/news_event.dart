import 'package:flutter/cupertino.dart';
@immutable
abstract class NewsEvent {}
class GetWorldWideNewsEvent extends NewsEvent{
 final int?pageCount;
 GetWorldWideNewsEvent({this.pageCount});
}
class NewsSearchEvent extends NewsEvent{
 final String keyWord;
 final DateTime date;
 final int pageCount;
 NewsSearchEvent({required this.keyWord,required this.date,required this.pageCount});
}