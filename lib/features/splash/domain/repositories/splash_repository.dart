import 'package:goanest/features/splash/domain/entities/splash_entity.dart';

abstract class SplashRepository {
  Future<List<SplashEntity>> getPost();
  Future<SplashEntity> createPost(SplashEntity post);
}
