import '../../../core.dart';

part 'error_model.g.dart';

@JsonSerializable()
class ErrorModel {
  final String? title;
  final String? subTitle;
  final String? image;
  final String? urlLabel;
  final String? redirectionUrl;
  final bool? isButtonEnable;
  final bool? isRestartRequired;

  ErrorModel({
    required this.title,
    required this.subTitle,
    required this.image,
    required this.urlLabel,
    required this.redirectionUrl,
    required this.isButtonEnable,
    required this.isRestartRequired,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => _$ErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
