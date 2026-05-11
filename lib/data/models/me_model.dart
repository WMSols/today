import 'package:today/data/models/auth_user_model.dart';
import 'package:today/domain/entities/me_entity.dart';

class WalletModel extends WalletEntity {
  const WalletModel({
    required super.id,
    required super.userId,
    required super.balance,
    required super.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      balance: (json['balance'] as num).toInt(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.timezone,
    required super.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      timezone: json['timezone'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class MeModel extends MeEntity {
  const MeModel({
    required super.user,
    required super.wallet,
    required super.profile,
  });

  factory MeModel.fromJson(Map<String, dynamic> json) {
    return MeModel(
      user: AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
      wallet: WalletModel.fromJson(json['wallet'] as Map<String, dynamic>),
      profile: json['profile'] == null
          ? null
          : ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
    );
  }
}
