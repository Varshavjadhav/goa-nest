// import 'package:http/http.dart' as http;
//
// import '/core.dart';
// import 'model/app_device_info_model.dart';
//
// class AppDeviceInfoService {
//   late final AppDeviceInfoModel appDeviceInfoModel;
//
//   Future<void> init() async {
//     final deviceInfo = DeviceInfoPlugin();
//     final platform = getPlatform();
//
//     final results = await Future.wait([
//       _getPublicIpAddress(),
//       _getNetworkType(),
//       _getUserAgentFromWebView(),
//       PackageInfo.fromPlatform(),
//       _getDeviceId(),
//     ]);
//
//     final ip = results[0] as String;
//     final networkType = results[1] as String;
//     final userAgent = results[2] as String?;
//     final packageInfo = results[3] as PackageInfo;
//     final deviceId = results[4] as String;
//
//     if (Platform.isAndroid) {
//       final android = await deviceInfo.androidInfo;
//       appDeviceInfoModel = AppDeviceInfoModel(
//         ip: ip,
//         initChannel: networkType,
//         osVersion: android.version.release,
//         deviceId: deviceId,
//         deviceName: android.model,
//         name: android.manufacturer,
//         brand: android.brand,
//         model: android.model,
//         userAgent: userAgent,
//         appId: packageInfo.packageName,
//         appVersion: packageInfo.version,
//         buildNumber: packageInfo.buildNumber,
//         platform: platform,
//       );
//     } else if (Platform.isIOS) {
//       final ios = await deviceInfo.iosInfo;
//       appDeviceInfoModel = AppDeviceInfoModel(
//         ip: ip,
//         initChannel: networkType,
//         deviceId: deviceId,
//         deviceName: ios.model,
//         name: ios.name,
//         brand: ios.localizedModel,
//         model: ios.modelName,
//         userAgent: userAgent,
//         osVersion: ios.systemVersion,
//         appId: packageInfo.packageName,
//         appVersion: packageInfo.version,
//         buildNumber: packageInfo.buildNumber,
//         platform: platform,
//       );
//     } else {
//       throw UnsupportedError('Unsupported platform');
//     }
//
//     log(appDeviceInfoModel.toJson().toString());
//   }
//
//   Future<String> _getNetworkType() async {
//     final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
//     return connectivityResult.isEmpty ? 'unknown' : connectivityResult.first.name;
//   }
//
//   // ! Not as per backend requirement but still used in SwipeLoan so let it be
//   /*Future<String> _getLocalIpAddress() async {
//     try {
//       final interfaces = await NetworkInterface.list();
//       for (var interface in interfaces) {
//         for (var addr in interface.addresses) {
//           if (addr.type == InternetAddressType.IPv4) {
//             return addr.address;
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('Failed to get local IP: $e');
//     }
//     return 'unknown';
//   }*/
//
//   Future<String> _getPublicIpAddress() async {
//     try {
//       final response = await http.get(Uri.parse('https://api.ipify.org'));
//       if (response.statusCode == 200) {
//         return response.body;
//       }
//     } catch (e) {
//       debugPrint('Failed to get public IP: $e');
//     }
//     return 'unknown';
//   }
//
//   Future<String> _getDeviceId() async {
//     try {
//       final String? deviceId = await UniqueDeviceIdentifier.getUniqueIdentifier();
//       return deviceId ?? "";
//     } catch (e) {
//       debugPrint('Failed to get Device ID: $e');
//     }
//     return 'unknown';
//   }
//
//   // ? Need to refactor this as it is not good to be called at the initial stage of application running
//   Future<String?> _getUserAgentFromWebView() async {
//     final controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadHtmlString('<html></html>');
//
//     final ua = await controller.runJavaScriptReturningResult('navigator.userAgent');
//     return ua is String ? ua : ua.toString().replaceAll('"', '');
//   }
//
//   String getPlatform() {
//     switch (Platform.operatingSystem) {
//       case 'android':
//         return 'android';
//       case 'ios':
//         return 'ios';
//       default:
//         return 'unknown';
//     }
//   }
// }
