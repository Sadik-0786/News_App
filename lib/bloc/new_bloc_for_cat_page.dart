import 'package:flutter_bloc/flutter_bloc.dart';

import '../api_urls/api_urls.dart';
import '../models/news_model/news_data_model.dart';
import '../responce/news_respo.dart';
import 'news_bloc.dart';
import 'news_event.dart';

class NewsBlocForCatPage extends Bloc<NewsEvent, NewsState> {
  News newsResponse;
  NewsBlocForCatPage({required this.newsResponse}) : super(NewsInitial()) {
    on<GetWorldWideNewsEvent>((event, emit) async {
      emit(NewsLoadingState());
      try{
        NewsModel res= await newsResponse.getApi(
            "${ApiUrls.curatedTopHeadLinesUrls}&pageSize=30&page=${event.pageCount}${ApiUrls.apiKey}");
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
