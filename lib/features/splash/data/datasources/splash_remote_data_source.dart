import 'package:goanest/features/splash/data/models/splash_model.dart';

abstract class SplashRemoteDataSource {
  Future<List<SplashModel>> getPost();
  Future<SplashModel> createPost(SplashModel splash);
}

class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
  @override
  Future<SplashModel> createPost(SplashModel splash) {
    // TODO: implement createPost
    throw UnimplementedError();
  }

  @override
  Future<List<SplashModel>> getPost() {
    // TODO: implement getPost
    throw UnimplementedError();
  }
}
