part of 'news_bloc.dart';

@immutable
abstract class NewsState {}

class NewsInitial extends NewsState {}
class NewsLoadingState extends NewsState{}
class NewsLoadedState extends NewsState{
  final NewsModel news;
  NewsLoadedState({required this.news});
}
class NewsErrorState extends NewsState{
  final String errorMessage;
  NewsErrorState({required this.errorMessage});
}

