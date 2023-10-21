import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:news_app/bloc/indian_news_bloc.dart';
import 'package:news_app/bloc/indian_news_bloc_for_category_page.dart';
import 'package:news_app/bloc/new_bloc_for_cat_page.dart';
import 'package:news_app/bloc/news_bloc.dart';
import 'package:news_app/bloc/news_event.dart';
import 'package:news_app/screens/read_news_page.dart';

import '../bloc/search_news_bloc.dart';
import '../models/news_model/news_data_model.dart';

class CategoryWiseNews extends StatefulWidget {
  const CategoryWiseNews({super.key, required this.catName, this.blocId});

  final String catName;
  /// blocId used to do separation of blocs
  /// if id=1 WorldWideCatBloc execute
  /// if id=2 IndianBlocForCat execute
  /// if id=3 NewsBlocForSearch execute
  final int? blocId;
  @override
  State<CategoryWiseNews> createState() => _CategoryWiseNewsState();
}

class _CategoryWiseNewsState extends State<CategoryWiseNews> {
  ScrollController _scrollController = ScrollController();
  int pageNumber = 1;
  int? totalResult;
  bool isThereError = false;
  String errorMessage = '';
  List<Articles> listOfArticles = [];

  @override
  void initState() {
    super.initState();
    widget.blocId == 1
        ? context
            .read<NewsBlocForCatPage>()
            .add(GetWorldWideNewsEvent(pageCount: pageNumber))
        : widget.blocId == 2
            ? context.read<IndianNewsBlocForCatPage>().add(GetIndianNewsEvent(
                category: widget.catName, pageCount: pageNumber))
            : widget.blocId == 3
                ? context.read<NewsBlocForSearch>().add(NewsSearchEvent(
                    keyWord: widget.catName.toLowerCase(),
                    date: DateTime.now(),pageCount: pageNumber))
                : null;
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (totalResult != null) {
            num numberOfPages;
            totalResult! % 20 == 0
                ? numberOfPages = totalResult! / 20
                : numberOfPages = (totalResult! / 20) + 1;
            if (pageNumber < numberOfPages) {
              pageNumber += 1;
              widget.blocId == 1
                  ? context
                      .read<NewsBlocForCatPage>()
                      .add(GetWorldWideNewsEvent(pageCount: pageNumber))
                  :  widget.blocId == 2?
              context.read<IndianNewsBlocForCatPage>().add(
                      GetIndianNewsEvent(
                          category: widget.catName, pageCount: pageNumber))
                  :  widget.blocId == 3?  context.read<NewsBlocForSearch>().add(
                 NewsSearchEvent(keyWord: widget.catName, date: DateTime.now(),pageCount: pageNumber))
                 : null;
            }
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Flutter',
            style: TextStyle(fontSize: 20.sp, color: Colors.black),
          ),
          Text('Khabri', style: TextStyle(fontSize: 22.sp, color: Colors.blue))
        ]),
        actions: const [
          Opacity(
            opacity: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.add),
            ),
          )
        ],
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.arrow_back_ios)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.catName,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${totalResult ?? 'Loading..'} Article Available',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade400),
              ),
              const SizedBox(
                height: 10,
              ),
              widget.blocId == 1
                  ? BlocListener<NewsBlocForCatPage, NewsState>(
                      listener: (context, state) {
                        if (state is NewsLoadingState) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Text(
                            'Loading More Articles.....',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16),
                          )));
                        } else if (state is NewsLoadedState) {
                          setState(() {
                            totalResult = state.news.totalResults!;
                            listOfArticles.addAll(state.news.articles!);
                          });
                        } else if (state is NewsErrorState) {
                          setState(() {
                            isThereError = true;
                            errorMessage = state.errorMessage;
                          });
                        }
                      },
                      child: Expanded(child: newsBuilder(listOfArticles)),
                    )
                  : widget.blocId == 2
                      ? BlocListener<IndianNewsBlocForCatPage, IndianNewsState>(
                          listener: (context, state) {
                            if (state is IndianNewsLoadingState) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text(
                                'Loading More Articles.....',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                              )));
                            } else if (state is IndianNewsLoadedState) {
                              setState(() {
                                totalResult = state.news.totalResults!;
                                listOfArticles.addAll(state.news.articles!);
                              });
                            } else if (state is IndianNewsErrorState) {
                              setState(() {
                                isThereError = true;
                                errorMessage = state.errorMessage;
                              });
                            }
                          },
                          child: Expanded(child: newsBuilder(listOfArticles)),
                        )
                      : widget.blocId == 3
                          ? BlocListener<NewsBlocForSearch, NewsState>(
                              listener: (context, state) {
                                if (state is NewsLoadingState) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                    'Loading More Articles.....',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  )));
                                } else if (state is NewsLoadedState) {
                                  setState(() {
                                    totalResult = state.news.totalResults!;
                                    listOfArticles.addAll(state.news.articles!);
                                  });
                                } else if (state is NewsErrorState) {
                                  setState(() {
                                    isThereError = true;
                                    errorMessage = state.errorMessage;
                                  });
                                }
                              },
                              child:
                                  Expanded(child: newsBuilder(listOfArticles)),
                            )
                          : Container(),
            ],
          ),
        ),
      ),
    );
  }
/// listView builder for creating news ui
  Widget newsBuilder(List<Articles> arrArticles) {
    return ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: arrArticles.length,
        itemBuilder: (context, index) {
          DateTime newsDateTime =
              DateTime.parse("${arrArticles[index].publishedAt}");
          var dateOfNews = DateFormat.yMEd().add_jms().format(newsDateTime);
          return arrArticles[index].urlToImage != null &&
                  arrArticles[index].description != null &&
                  arrArticles[index].author != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReadNewsPage(
                                    newsUrl: arrArticles[index].url)));
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25)),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.network(
                                      '${arrArticles[index].urlToImage}',
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(dateOfNews,
                                    style: TextStyle(
                                        color: Colors.blue.shade400,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15))
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${arrArticles[index].title}',
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${arrArticles[index].description}',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400),
                            ),
                          ])),
                )
              : const SizedBox();
        });
  }
}
