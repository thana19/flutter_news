import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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
           return ListTile (
             leading: SizedBox(
               height: 100,
                width: 100,
                child: Image.network(articles[index]['urlToImage'],fit: BoxFit.cover)
             ),
             title: Text(articles[index]['title']),
             subtitle: Text(articles[index]['source']['name']),
           );
        },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: articles.length
      ),
    );
  }
}
