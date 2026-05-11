import 'package:today/domain/entities/auth_user_entity.dart';

class WalletEntity {
  const WalletEntity({
    required this.id,
    required this.userId,
    required this.balance,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final int balance;
  final DateTime updatedAt;
}

class ProfileEntity {
  const ProfileEntity({
    required this.id,
    required this.timezone,
    required this.createdAt,
  });

  final String id;
  final String timezone;
  final DateTime createdAt;
}

class MeEntity {
  const MeEntity({
    required this.user,
    required this.wallet,
    required this.profile,
  });

  final AuthUserEntity user;
  final WalletEntity wallet;
  final ProfileEntity? profile;
}
