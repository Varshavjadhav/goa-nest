import 'package:equatable/equatable.dart';

class SplashEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;

  const SplashEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  @override
  List<Object?> get props => [id, userId, title, body];
}
