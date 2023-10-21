import 'package:flutter/cupertino.dart';
import 'package:news_app/api_urls/api_urls.dart';
import 'package:news_app/models/news_model/news_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../responce/news_respo.dart';
import 'news_event.dart';
part 'news_state.dart';
class NewsBloc extends Bloc<NewsEvent, NewsState> {
 News newsResponse;
  NewsBloc({required this.newsResponse}) : super(NewsInitial()) {
    on<GetWorldWideNewsEvent>((event, emit) async {
    emit(NewsLoadingState());
     try{
       NewsModel res= await newsResponse.getApi(
           "${ApiUrls.curatedTopHeadLinesUrls}&pageSize=30${ApiUrls.apiKey}");
       emit(NewsLoadedState(news:res));
     }catch(exception){
       emit(NewsErrorState(errorMessage: exception.toString()));
     }
    }
    );
    on<NewsSearchEvent>((event, emit) async {
      emit(NewsLoadingState());
      try{
        NewsModel res=await newsResponse.getApi('${ApiUrls.searchUrl}q=${event.keyWord}&from=${event.date}&sortBy=publishedAt${ApiUrls.apiKey}');
        emit(NewsLoadedState(news: res));
      }catch(exception){
        emit(NewsErrorState(errorMessage:exception.toString()));
      }
    });
  }
}
