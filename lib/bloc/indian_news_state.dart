part of 'indian_news_bloc.dart';

@immutable
abstract class IndianNewsState {}

class IndianNewsInitial extends IndianNewsState {}
class IndianNewsLoadingState extends IndianNewsState{}
class IndianNewsLoadedState extends IndianNewsState{
  final NewsModel news;
  IndianNewsLoadedState({required this.news});
}
class IndianNewsErrorState extends IndianNewsState{
  final String errorMessage;
  IndianNewsErrorState({required this.errorMessage});
}