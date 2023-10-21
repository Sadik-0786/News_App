
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api_urls/api_urls.dart';
import '../models/news_model/news_data_model.dart';
import '../responce/news_respo.dart';
import 'news_bloc.dart';
import 'news_event.dart';

class NewsBlocForSearch extends Bloc<NewsEvent, NewsState> {
  News newsResponse;
  NewsBlocForSearch({required this.newsResponse}) : super(NewsInitial()) {

    on<NewsSearchEvent>((event, emit) async {
      emit(NewsLoadingState());
      try{
        NewsModel res=await newsResponse.getApi('${ApiUrls.searchUrl}q=${event.keyWord}&page=${event.pageCount}${ApiUrls.apiKey}');
        emit(NewsLoadedState(news: res));
      }catch(exception){
        emit(NewsErrorState(errorMessage:exception.toString()));
      }
    });
  }
}
