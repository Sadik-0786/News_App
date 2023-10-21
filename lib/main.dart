import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/bloc/indian_news_bloc.dart';
import 'package:news_app/bloc/indian_news_bloc_for_category_page.dart';
import 'package:news_app/bloc/new_bloc_for_cat_page.dart';
import 'package:news_app/bloc/news_bloc.dart';
import 'package:news_app/bloc/search_news_bloc.dart';
import 'package:news_app/responce/news_respo.dart';
import 'package:news_app/screens/home_page.dart';

void main() {
  runApp(MultiBlocProvider(
      providers:[
        BlocProvider<NewsBloc>(create: (BuildContext context)=>NewsBloc(newsResponse: News())),
        BlocProvider<NewsBlocForCatPage>(create: (BuildContext context)=>NewsBlocForCatPage(newsResponse: News())),
        BlocProvider<IndianNewsBloc>(create: (BuildContext context)=>IndianNewsBloc(newsResponse: News())),
        BlocProvider<IndianNewsBlocForCatPage>(create: (BuildContext context)=>IndianNewsBlocForCatPage(newsResponse: News())),
        BlocProvider<NewsBlocForSearch>(create: (BuildContext context)=>NewsBlocForSearch(newsResponse: News())),
  ], child: const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  )
  ),

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) => MaterialApp(

        debugShowCheckedModeBanner: false,
        builder: (context, widget) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: const HomePage()),
        title: 'News App',
      ),
    );
  }
}
