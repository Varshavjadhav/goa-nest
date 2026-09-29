import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goanest/app/router/route_name.dart';
import 'package:goanest/core/data/network/service/base_api_service.dart';
import 'package:goanest/core/services/local_secure_storage/secure_storage_service.dart';
import 'package:goanest/features/login/data/model/token_refresh_model.dart';
import 'package:goanest/resources/constants/flags.dart';
import 'package:goanest/resources/constants/url_end_points.dart';

import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SecureStorageService storage;
  final BaseApiServices api;

  SplashBloc(this.storage, this.api) : super(const SplashInitialState()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoadingState());
    var nextRoute = RouteName.loginView;
    try {
      final accessToken = await storage.read<String>(Flags.token);
      final refreshToken = await storage.read<String>(Flags.refreshToken);

      if (_isAccessTokenValid(accessToken)) {
        await storage.write(Flags.isLoggedIn, true);
        nextRoute = RouteName.homeView;
      } else if (refreshToken != null && refreshToken.isNotEmpty) {
        final refreshed = await _refreshSession(refreshToken);
        if (refreshed) {
          nextRoute = RouteName.homeView;
        } else {
          await _clearSession();
        }
      } else {
        await _clearSession();
      }
    } catch (_) {
      await _clearSession();
    }

    await Future<void>.delayed(const Duration(seconds: 2));
    if (!emit.isDone) emit(SplashReadyState(nextRoute: nextRoute));
  }

  bool _isAccessTokenValid(String? token) {
    if (token == null || token.isEmpty) return false;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final expiry = (payload as Map<String, dynamic>)['exp'];
      if (expiry is! num) return false;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return expiry.toInt() > now + 30;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _refreshSession(String refreshToken) async {
    final result = await api.postApi<TokenRefreshResponse>(
      ApiUrl.refreshToken,
      const {},
      TokenRefreshResponse.fromJson,
      body: {'refreshToken': refreshToken},
      disableTokenValidityCheck: true,
    );
    if (result.isLeft()) return false;

    final response = result.getOrElse(
      () => throw StateError('Missing refresh response'),
    );
    final tokens = response.data;
    if (tokens == null ||
        tokens.accessToken.isEmpty ||
        tokens.refreshToken.isEmpty) {
      return false;
    }

    await storage.write(Flags.token, tokens.accessToken);
    await storage.write(Flags.refreshToken, tokens.refreshToken);
    await storage.write(Flags.isLoggedIn, true);
    return true;
  }

  Future<void> _clearSession() async {
    await storage.delete(Flags.token);
    await storage.delete(Flags.refreshToken);
    await storage.delete(Flags.user);
    await storage.write(Flags.isLoggedIn, false);
  }
}
