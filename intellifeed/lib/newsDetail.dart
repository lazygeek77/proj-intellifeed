import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:intellifeed/model/news.dart';

class NewsDetail extends StatefulWidget {
  final News news;
  NewsDetail(this.news);
  
  @override
  State<StatefulWidget> createState() {
    return NewsDetailState(this.news);
  }
}

class NewsDetailState extends State<NewsDetail> {
  final News news;
  HtmlView html;

  NewsDetailState(this.news);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
                appBar: AppBar(
                  title: Text('News Detail'),
                ),
                body: _renderNewsDetail(),
            );
  }

  Widget _renderNewsDetail() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        border: Border.all(
          color: Colors.orangeAccent,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column (
          //scrollDirection: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            _renderNewsDetailImage(),
            _renderNewsDetailTitle(),
            _renderNewsDetailDesc(),
            _renderURLLauncher()
          ]
      ),
    );
  }

  Widget _renderNewsDetailImage(){
    //return Text(this.news.imageUrl);
    return Container(
      constraints: BoxConstraints.tight(Size(180.0, 180.0)),
      child: Image.network(
        this.news.imageUrl,
        fit: BoxFit.fitWidth)
    );
  }

  Widget _renderNewsDetailTitle(){
    return Container(
      //constraints: BoxConstraints.tightFor(height: 100),
      child: Text(this.news.title));
  }
  
  Widget _renderNewsDetailDesc(){
    return Container(
      //constraints: BoxConstraints.tightFor(height: 100),
      child: Text(this.news.desc));

    // print('In _renderNewsDetailDesc');
    // Future resp = News.fetchDescDetail(this.news.srcUrl);
    // resp.then((rspHtml){
    //    print('processing future');
    //    setState(() {
    //       html = new HtmlView(data: rspHtml);
    //    }); 
    // }).catchError((e) {return null;});

    // return SingleChildScrollView(
    //   //constraints: BoxConstraints.tightFor(height: 100),
    //   child: Center(
    //     child: this.html));
  }

  Widget _renderURLLauncher() {
    return Center(
      child: RaisedButton(
        onPressed: _launchURL,
        child: Text('Launch'),
      ),
    );
  }

  _launchURL() async {
    String url = this.news.srcUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
