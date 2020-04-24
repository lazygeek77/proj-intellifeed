import "package:json_annotation/json_annotation.dart";
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
part 'news.g.dart';


@JsonSerializable()
class News {
  final String id;
  final String title;
  final String desc;
  final String imageUrl;
  final String srcUrl;
  final String pubDate;
  //String serverUrl = 'http://10.0.2.2:5000/'; 

  News({this.srcUrl, this.desc, this.imageUrl, this.id, this.title, this.pubDate});

  News.blank()
      : id = '',
        title = '',
        srcUrl = '',
        desc = '',
        imageUrl = '',
        pubDate='';

  factory News.fromJson(Map<String, dynamic> json) =>
      _$NewsFromJson(json);

  static Future<List<News>> fetchAll() async {
    //print ('$serverUrl');
    //final resp = await http.get('$serverUrl/all-news');
    final resp = await http.get(Uri.encodeFull("http://10.0.2.2:5000/get-feeds"), headers: {"Accept": "application/json"});

    if (resp.statusCode != 200) {
      throw (resp.body);
    }
    else {
      print (resp.request.url);
      //print (resp.body);
    }
    List<News> list = new List<News>();
    var jsonTree = json.decode(resp.body);
    List jsonNewsItems = jsonTree['newsItems']; 

    for (Map<String, dynamic> jsonItem in jsonNewsItems) {
      list.add(News.fromJson(jsonItem));
    }

    // print(list);
    
    return list;
  }
  

  static Future<String> fetchDescDetail(String url) async{
    final resp = await http.get(Uri.encodeFull(url));

    if (resp.statusCode != 200) {
      throw (resp.body);
    }
    else {
      print (resp.request.url);
      print (resp.body);
    }
    return resp.body;    
  }
  // static Future<News> fetchByID(int id) async {
  //   var uri = Endpoint.uri('/locations/$id');

  //   final resp = await http.get(uri.toString());

  //   if (resp.statusCode != 200) {
  //     throw (resp.body);
  //   }
  //   final Map<String, dynamic> itemMap = json.decode(resp.body);
  //   return News.fromJson(itemMap);
  // }

  // static Future<News> fetchAny() async {
  //   return News.fetchByID(1);
  //}
}
