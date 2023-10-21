import 'package:flutter_bloc/flutter_bloc.dart';

import '../api_urls/api_urls.dart';
import '../models/news_model/news_data_model.dart';
import '../responce/news_respo.dart';
import 'indian_news_bloc.dart';


class IndianNewsBlocForCatPage extends Bloc<IndianNewsEvent, IndianNewsState> {
  News newsResponse;
  IndianNewsBlocForCatPage({required this.newsResponse}) : super(IndianNewsInitial()) {
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
