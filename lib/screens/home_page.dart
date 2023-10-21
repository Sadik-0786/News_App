import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:news_app/app_const;.dart';
import 'package:news_app/bloc/indian_news_bloc.dart';
import 'package:news_app/bloc/news_bloc.dart';
import 'package:news_app/bloc/news_event.dart';
import 'package:news_app/screens/category_wise_news.dart';
import 'package:news_app/screens/read_news_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String catName='General';
  bool isVisible=false;
  final TextEditingController _searchController=TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(GetWorldWideNewsEvent());
    context.read<IndianNewsBloc>().add(GetIndianNewsEvent());
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Stack(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isVisible?Colors.white:Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child:Text('Flutter',style: TextStyle(fontSize:20.sp,color: Colors.white,fontWeight: FontWeight.bold),),),
                        const SizedBox(width: 6,),
                        Text('Khabri',style:TextStyle(fontSize:18.sp,color: Colors.blue,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                   InkWell(
                     onTap: (){
                      setState(() {
                        isVisible=true;
                      });
                     },
                       child: Icon(Icons.search,color: Colors.grey,size: 23.sp))
                ] ),
            Visibility(
              visible: isVisible,
              child:  Container(
                height: 45.sp,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.sp),
                  color:Colors.transparent,
                ),
                child:TextFormField(
                  controller: _searchController,
                  onFieldSubmitted: (value) async {
                    setState(() {
                      isVisible=!isVisible;
                    });
                    if(_searchController.text!=''){
                      await Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryWiseNews(catName:_searchController.text,blocId: 3,)));
                      _searchController.clear();
                    }
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'Search Latest News_',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400, fontSize: 16.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.sp),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5.sp, color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(15.sp)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                          ),
                          borderRadius: BorderRadius.circular(15.sp)),
                      suffixIcon: InkWell(
                        onTap: () async {
                          setState(() {
                            isVisible=!isVisible;
                          });
                          if(_searchController.text!=''){
                            await Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryWiseNews(catName:_searchController.text,blocId: 3,)));
                            _searchController.clear();
                          }
                        },
                        child: Icon(
                          Icons.search_sharp,
                          size: 25.sp,
                          color: Colors.grey.shade400,
                        ),
                      )),
                ),
              ),
            )
          ]),
        ),
        body:Padding(
          padding:  EdgeInsets.all(8.0.sp),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Braking News',style:TextStyle(fontWeight: FontWeight.w500,fontSize: 20.sp),),
                  InkWell(
                      onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>const CategoryWiseNews(catName: "World Wide Breaking News",blocId: 1,)));
                      },
                      child: Text('Show More',style:TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp,color:Colors.grey.shade400),)),
                ],),
              BlocBuilder<NewsBloc,NewsState>(
                  builder: (context,state){
                    if(state is NewsLoadingState){
                      return const Expanded(child:  Center(child: CircularProgressIndicator()));
                    }
                    else if(state is NewsLoadedState){
                     return Column(
                       children: [
                         Container(
                           height:220,
                           width: double.infinity,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(25)
                           ),
                           child: worldWideNewsPanel(state),
                         ),
                         const SizedBox(height: 10,),
                       ],
                     );
                    }
                    else if(state is NewsErrorState){
                      return Text(state.errorMessage);
                    }
                    return Container();
                  }

                  ),
              getCategory(),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Recommended for you',style:TextStyle(fontWeight: FontWeight.w500,fontSize: 20.sp),),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryWiseNews(catName: catName,blocId: 2,)));
                    },
                      child: Text('Show More',style:TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp,color:Colors.grey.shade400),)),
                ],),
              const SizedBox(height: 10,),
              BlocBuilder<IndianNewsBloc,IndianNewsState>(                        builder: (context,state){
                if(state is IndianNewsLoadingState){
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                }
                else if(state is IndianNewsLoadedState){
                  return Expanded(child: indianNewsList(state));
                }
                else if(state is IndianNewsErrorState){
                  return Text(state.errorMessage);
                }
                return Container();
              } )
            ],
          ),
        )
      ),
    );
  }
  Widget getCategory(){
    return Container(
      height:50.sp,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.sp)
      ),
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: AppConst.listOfCategory.length,
          itemBuilder: (context,index){
            return Padding(
              padding: EdgeInsets.all(5.0.sp),
              child: InkWell(
                onTap: (){
                  catName=AppConst.listOfCategory[index]['categoryName']!;
                  //print(catName);
                  context.read<IndianNewsBloc>().add(GetIndianNewsEvent(category:AppConst.listOfCategory[index]['categoryName'] ));
                },
                child: Container(
                  height:50.sp,
                  width: 150.sp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.sp),
                    image: DecorationImage(image:AssetImage(AppConst.listOfCategory[index]['imageUrl']!),fit: BoxFit.cover)
                  ),
                  child: Center(child: Text(AppConst.listOfCategory[index]['categoryName']!,style: TextStyle(fontSize: 20.sp,color: Colors.white,fontWeight: FontWeight.bold),),),
                ),
              ),
            );
          }),
    );
  }
  Widget worldWideNewsPanel(NewsLoadedState state){
    return ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
      return state.news.articles![index].urlToImage != null && state.news.articles![index].description != null ? Padding(
        padding: const EdgeInsets.only(top: 8),
        child: InkWell(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>ReadNewsPage(newsUrl: state.news.articles![index].url)));
          },
          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.sp),
            ),
            child:SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      height:200,
                     decoration: BoxDecoration(
                       borderRadius:BorderRadius.circular(25),
                       image: DecorationImage(image:NetworkImage('${state.news.articles![index].urlToImage}'),fit: BoxFit.cover),
                     ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Public by:${state.news.articles![index].source!.name}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.sp,color: Colors.white),),
                            const SizedBox(height: 4,),
                            Text('${state.news.articles![index].title}',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp,color: Colors.white),),
                          ],
                        )
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ): Container();
    });
  }
  Widget indianNewsList(IndianNewsLoadedState state){
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount:10,
        itemBuilder: (context,index){
          DateTime newsDateTime=DateTime.parse("${state.news.articles![index].publishedAt}");
          var dateOfNews=DateFormat.yMEd().add_jms().format(newsDateTime );
      return state.news.articles![index].urlToImage!=null&& state.news.articles![index].description!=null&& state.news.articles![index].author!=null? Padding(
        padding: const EdgeInsets.only(top: 5),
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ReadNewsPage(newsUrl: state.news.articles![index].url)));
          },
          child: ListTile(
            leading: Container(
                width: 80.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15)
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network('${state.news.articles![index].urlToImage}' ,height:100,fit: BoxFit.cover,))),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Author:',style:  TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w900),),
                    Text('${state.news.articles![index].author!.length<=20?state.news.articles![index].author:'Not found'}',style:  TextStyle(fontSize: 12.sp,fontWeight: FontWeight.bold,color: Colors.grey.shade400,),),
                  ],
                ),
                const SizedBox(height: 3,),
                Text('${state.news.articles![index].title}',style:  TextStyle(fontSize: 15.sp,fontWeight: FontWeight.w500),maxLines: 2,),
              ],
            ),
            subtitle: Column(
              children: [
                const SizedBox(height: 3,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                 Text(dateOfNews,style: TextStyle(color: Colors.blue.shade400,fontWeight: FontWeight.w500,fontSize: 12))
                ],),
              ],
            ),
          ),
        ),
      ):const SizedBox();
    });
  }
}
