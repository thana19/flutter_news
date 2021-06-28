import 'package:flutter/material.dart';
import 'package:flutter_news/pages/WebViewPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsPages extends StatefulWidget {
  const NewsPages({Key? key}) : super(key: key);

  @override
  _NewsPagesState createState() => _NewsPagesState();
}

class _NewsPagesState extends State<NewsPages> {
  List<dynamic> articles = [];
  int totalResults = 0;
  bool isLoading = true;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  int page = 1;
  int pageSize = 5 ;

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      page = 1;
    });
    _getData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    if(mounted) {
      setState(() {
        page = ++page;
      });
      _getData();
    }
    _refreshController.loadComplete();
  }

  _getData()async {
    try {
      var url = Uri.parse(
          'https://newsapi.org/v2/everything?q=apple&apiKey=44377980b970429b8fbfac5b6f13e55f&page=$page&pageSize=$pageSize');
      var response = await http.get(url);

      final Map<String, dynamic> news = convert.jsonDecode(response.body);
      setState(() {
        page == 1 ? articles = news['articles']:
                    articles.addAll(news['articles']);
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
          SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child:
            ListView.separated(itemBuilder: (BuildContext context, int index){
              return Card (
                  child: InkWell (
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WebViewPage(),
                              settings: RouteSettings(
                                  arguments: {
                                    'name' : articles[index]['source']['name'],
                                    'url' : articles[index]['url'],
                                  }
                              )
                          )
                      );
                      print('${articles[index]['url']}');
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
          )

    );
  }
}
