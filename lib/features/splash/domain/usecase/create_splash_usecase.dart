import 'package:goanest/features/splash/domain/entities/splash_entity.dart';

import '../../../../core/usecases/usecase.dart';
import '../repositories/splash_repository.dart';

class CreateSplashUseCase implements Usecase<SplashEntity, SplashEntity> {
  final SplashRepository splashRepository;
  CreateSplashUseCase(this.splashRepository);

  @override
  Future<SplashEntity> call(SplashEntity splash) {
    // TODO: implement call
    return splashRepository.createPost(splash);
  }

  // Future<SplashEntity> call(SplashEntity splash) {
  //   return splashRepository.createPost(splash);
  // }
}
