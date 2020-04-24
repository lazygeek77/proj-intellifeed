// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) {
  return News(
      srcUrl: json['srcUrl'] as String,
      desc: json['desc'] as String,
      imageUrl: json['imageUrl'] as String,
      id: json['id'] as String,
      title: json['title'] as String,
      pubDate: json['pubDate'] as String);
}

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'desc': instance.desc,
      'imageUrl': instance.imageUrl,
      'srcUrl': instance.srcUrl,
      'pubDate': instance.pubDate
    };
