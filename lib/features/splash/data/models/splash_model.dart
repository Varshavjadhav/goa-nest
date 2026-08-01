import 'package:goanest/features/splash/domain/entities/splash_entity.dart';

class SplashModel extends SplashEntity {
  const SplashModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.body,
  });

  factory SplashModel.fromEntity(SplashEntity entity) {
    return SplashModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      body: entity.body,
    );
  }
}
