import 'package:goanest/core/usecases/usecase.dart';
import 'package:goanest/features/splash/domain/repositories/splash_repository.dart';

import '../entities/splash_entity.dart';

class GetSplashUseCase implements Usecase<List<SplashEntity>, NoParams> {
  final SplashRepository splashRepository;
  GetSplashUseCase(this.splashRepository);

  @override
  Future<List<SplashEntity>> call(NoParams params) {
    // TODO: implement call
    return splashRepository.getPost();
  }

  // Future<List<SplashEntity>> call() {
  //   return splashRepository.getPost();
  // }
}
