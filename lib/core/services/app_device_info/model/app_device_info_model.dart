import '.../../../../../../core.dart';

part 'app_device_info_model.g.dart';

@JsonSerializable()
class AppDeviceInfoModel {
  final String initChannel;
  final String ip;
  final String? userAgent;
  final String? brand;
  final String? model;
  final String? deviceId;
  final String? deviceName;
  final String? name;
  final String? appVersion;
  final String? appId;
  final String? buildNumber;
  final String? platform;
  final String? osVersion;

  AppDeviceInfoModel({
    required this.initChannel,
    required this.ip,
    this.userAgent,
    this.brand,
    this.model,
    this.deviceId,
    this.deviceName,
    this.name,
    this.appVersion,
    this.appId,
    this.buildNumber,
    this.platform,
    this.osVersion,
  });

  factory AppDeviceInfoModel.fromJson(Map<String, dynamic> json) => _$AppDeviceInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppDeviceInfoModelToJson(this);
}
