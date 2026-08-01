import 'package:goanest/features/splash/data/datasources/splash_remote_data_source.dart';
import 'package:goanest/features/splash/data/models/splash_model.dart';
import 'package:goanest/features/splash/domain/entities/splash_entity.dart';
import 'package:goanest/features/splash/domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashRemoteDataSource splashRemoteDataSource;
  SplashRepositoryImpl({required this.splashRemoteDataSource});
  @override
  Future<SplashEntity> createPost(SplashEntity post) {
    return splashRemoteDataSource.createPost(
      post is SplashModel ? post : SplashModel.fromEntity(post),
    );
  }

  @override
  Future<List<SplashEntity>> getPost() {
    // TODO: implement getPost
    return splashRemoteDataSource.getPost();
  }
}
