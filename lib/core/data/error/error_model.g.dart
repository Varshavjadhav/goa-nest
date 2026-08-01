// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorModel _$ErrorModelFromJson(Map<String, dynamic> json) => ErrorModel(
  title: json['title'] as String?,
  subTitle: json['subTitle'] as String?,
  image: json['image'] as String?,
  urlLabel: json['urlLabel'] as String?,
  redirectionUrl: json['redirectionUrl'] as String?,
  isButtonEnable: json['isButtonEnable'] as bool?,
  isRestartRequired: json['isRestartRequired'] as bool?,
);

Map<String, dynamic> _$ErrorModelToJson(ErrorModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subTitle': instance.subTitle,
      'image': instance.image,
      'urlLabel': instance.urlLabel,
      'redirectionUrl': instance.redirectionUrl,
      'isButtonEnable': instance.isButtonEnable,
      'isRestartRequired': instance.isRestartRequired,
    };
