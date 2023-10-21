import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../api_urls/api_urls.dart';
import '../models/news_model/news_data_model.dart';
import '../responce/news_respo.dart';

part 'indian_news_event.dart';
part 'indian_news_state.dart';

class IndianNewsBloc extends Bloc<IndianNewsEvent, IndianNewsState> {
  News newsResponse;
  IndianNewsBloc({required this.newsResponse}) : super(IndianNewsInitial()) {
    on<GetIndianNewsEvent>((event, emit) async {
      emit(IndianNewsLoadingState());
      try{
        NewsModel res=await newsResponse.getApi(
            "${ApiUrls.curatedTopHeadLinesCountryWiseUrls}category=${event.category??'general'}&pageSize=20&page=${event.pageCount??1}${ApiUrls.apiKey}"
        );
        emit(IndianNewsLoadedState(news: res));
      }catch(exception){
        emit(IndianNewsErrorState(errorMessage: exception.toString()));
      }
    });
  }
}
