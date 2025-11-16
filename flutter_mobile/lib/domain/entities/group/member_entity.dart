// flutter_mobile/lib/domain/entities/group/member_entity.dart
class MemberEntity {
  MemberEntity({
    required this.userId,
    required this.username,
    required this.role,
    this.profileImageUrl,
  });

  final String userId;
  final String username;
  final String role;
  final String? profileImageUrl;
}