// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_device_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppDeviceInfoModel _$AppDeviceInfoModelFromJson(Map<String, dynamic> json) =>
    AppDeviceInfoModel(
      initChannel: json['initChannel'] as String,
      ip: json['ip'] as String,
      userAgent: json['userAgent'] as String?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      deviceId: json['deviceId'] as String?,
      deviceName: json['deviceName'] as String?,
      name: json['name'] as String?,
      appVersion: json['appVersion'] as String?,
      appId: json['appId'] as String?,
      buildNumber: json['buildNumber'] as String?,
      platform: json['platform'] as String?,
      osVersion: json['osVersion'] as String?,
    );

Map<String, dynamic> _$AppDeviceInfoModelToJson(AppDeviceInfoModel instance) =>
    <String, dynamic>{
      'initChannel': instance.initChannel,
      'ip': instance.ip,
      'userAgent': instance.userAgent,
      'brand': instance.brand,
      'model': instance.model,
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'name': instance.name,
      'appVersion': instance.appVersion,
      'appId': instance.appId,
      'buildNumber': instance.buildNumber,
      'platform': instance.platform,
      'osVersion': instance.osVersion,
    };
