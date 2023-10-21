import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReadNewsPage extends StatelessWidget {
  const ReadNewsPage({super.key,required this.newsUrl});
 final String?newsUrl;

 WebViewController getLinkInController(){
   var controller=WebViewController()
     ..setJavaScriptMode(JavaScriptMode.disabled)
     ..loadRequest(Uri.parse(newsUrl!));
   return controller;
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Text('Flutter',style: TextStyle(fontSize:20.sp,color: Colors.black ),),
              Text('Khabri',style:TextStyle(fontSize:22.sp,color: Colors.blue))
            ] ),
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
          onTap: (){
            Navigator.pop(context);
          },
          child: const CircleAvatar(
              backgroundColor:Colors.transparent,child: Icon(Icons.arrow_back_ios)),
        ),
      ) ,
      body: WebViewWidget(
        controller: getLinkInController(),
      ),
    );
  }
}
