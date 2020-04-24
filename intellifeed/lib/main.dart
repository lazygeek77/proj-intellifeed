import 'package:flutter/material.dart';
import 'dart:async';

import 'package:intellifeed/model/news.dart';
import 'package:intellifeed/newsDetail.dart';


void main() => runApp(Intellifeed());

class Intellifeed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IntellifeedState(); 
}

class IntellifeedState extends State<Intellifeed>  with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'You'),
    Tab(text: 'Trending'),
    Tab(text: 'Latest'),
    Tab(text: 'Latest1'),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync:this, length: myTabs.length);
  } 

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intellifeed',
      home: _renderHomePage(context),
    );
  }

  Widget _renderHomePage(BuildContext context) {
    return Scaffold(
                appBar: AppBar(
                  title: Text('Intellifeed'),
                  bottom: TabBar(
                    controller: _tabController,
                    tabs: myTabs,
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: myTabs.map((Tab tab) {
                    return Center(child: NewsItems(tab.text));
                  }).toList(),
                ),
                drawer: _renderDrawer(context),
            );
  }

  Widget _renderDrawer(BuildContext context) {
    return (Drawer (
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Intellifeed'),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            title: Text('Setting'),
            onTap: (){},
          ),
          ListTile(
            title: Text('Setting-pop'),
            onTap: (){Navigator.pop(context);},
          ),
          AboutListTile(applicationName: 'Intellifeed', applicationVersion: '1.0.0',)

        ],
      )
    )

    );
  }
}
  
class NewsItems extends StatefulWidget {
  final String _tabType;

  NewsItems(this._tabType);

  @override
  State<StatefulWidget> createState() {
    return NewsItemsState(this._tabType);
  }
}

class NewsItemsState extends State<NewsItems> {
  final _newsItemList = <dynamic>[];
  final String _tabType;
   
  NewsItemsState(this._tabType);
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: _renderNISListView(context));
  }// build
  
  Widget _renderNISListView(BuildContext context){
    return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemBuilder: (BuildContext context, int index) {
              //print("index $index");
              if (index == _newsItemList.length) {
                _getNextNewsEntry(index, _tabType);
              }
              return ((index < _newsItemList.length) ? _newsItemList[index]: null);
            },
          );
  }

  void _getNextNewsEntry(int index, String _tabType) {
    try{
      // Future<List<News>> newsList = News.fetchAll();
      Future newsList = News.fetchAll();
      
      List <NewsEntry> entryList = new List<NewsEntry>();

      // newsList.then((List<News> list){
      newsList.then((list){
        //print("Processoing future..");
        for (News item in list) {
          //print("Add a NewsEntry ${item.id}");
          entryList.add(new NewsEntry(index, _tabType, item));
          //print("entryList.lenght ${entryList.length}");
        }
        setState((){_newsItemList.addAll(entryList);});
        //print("_newsItemList.length ${_newsItemList.length}");
      }).catchError((Error e) {print(e.stackTrace);});
    }
    catch(e){
      print(e.toString());
    }
  }//_getNextNewsEntry
}//class NewsItemsState 

class NewsEntry extends StatelessWidget{
  final int index;
  final String _tabType;
  final News news;

  NewsEntry(this.index, this._tabType, this.news);

  @override
  Widget build(BuildContext context) {
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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _renderNewsEntryListTile(context)
      ),
    );
  }

  List<Widget> _renderNewsEntryListTile(context) {
    return <Widget> [ 
          ListTile(
            contentPadding: EdgeInsets.all(10.0),
            title: Text(this.news.title),
            subtitle: Text(this.news.desc),
            trailing: _renderNewsEntryImage(),
            dense: false,
            onTap: () {
                //print('tapped cursor ${this.news.id}');
                _navigateToNewsEntryDetail(context);
            },
          ),
          Container(padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
            child: Text(this.news.pubDate, 
          textAlign: TextAlign.left,  
          style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic) ))];
  }//_renderNewsEntryListTile

  Widget _renderNewsEntryImage(){
    return Container(
      constraints: BoxConstraints.tight(Size(80.0, 80.0)),
      child: Image.network(
        this.news.imageUrl,
        fit: BoxFit.fitWidth)
      //  child: Image(
      //   image: AssetImage('images/Desert.jpg'),
      //   fit:BoxFit.fitWidth,
      //   //width: 120,
      //   //height: 70,
      // )
    );
  }



  void _navigateToNewsEntryDetail(BuildContext context) {
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => NewsDetail(this.news)));
  }//_navigateToNewsEntryDetail
}

