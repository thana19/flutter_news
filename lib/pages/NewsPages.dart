import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:intl/intl.dart';

class NewsPages extends StatefulWidget {
  const NewsPages({Key? key}) : super(key: key);

  @override
  _NewsPagesState createState() => _NewsPagesState();
}

class _NewsPagesState extends State<NewsPages> {
  List<dynamic> articles = [];
  int totalResults = 0;
  bool isLoading = true;

  _getData()async {
    try {
      var url = Uri.parse(
          'https://newsapi.org/v2/everything?q=apple&from=2021-06-22&to=2021-06-22&sortBy=popularity&apiKey=44377980b970429b8fbfac5b6f13e55f');
      var response = await http.get(url);

      final Map<String, dynamic> news = convert.jsonDecode(response.body);
      setState(() {
        articles = news['articles'];
        totalResults = news['totalResults'];
        isLoading = false;
      });

    } catch(e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: totalResults > 0 ? Text('News ($totalResults)') : Text('News')
      ),
      body:
        ListView.separated(itemBuilder: (BuildContext context, int index){
           return Card (
             child: InkWell (
               onTap: () {
                 print('tap');
               },
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   SizedBox(
                     // height: 150,
                       child: Image.network(articles[index]['urlToImage'],fit: BoxFit.cover)
                   ),
                   Padding(
                       padding: EdgeInsets.fromLTRB(16, 5, 10, 5),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text(articles[index]['source']['name']),
                           Text(DateFormat.yMMMd().format(DateTime.parse(articles[index]['publishedAt'])))
                         ],
                       )
                   ),
                   Padding(
                     padding: EdgeInsets.fromLTRB(16, 5, 10, 10),
                     child:  Text(articles[index]['title']),
                   ),
                 ],
               ),
             )
           );
        },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: articles.length
      ),
    );
  }
}
