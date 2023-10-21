part of 'indian_news_bloc.dart';

@immutable
abstract class IndianNewsEvent {}
class GetIndianNewsEvent extends IndianNewsEvent{
  final int?pageCount;
  final String?category;
  GetIndianNewsEvent({this.pageCount,this.category});
}