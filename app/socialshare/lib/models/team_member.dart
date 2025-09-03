import 'package:cloud_firestore/cloud_firestore.dart';

class TeamMember {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final List<String> permissions; // 'create', 'edit', 'delete', 'publish'
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int postCount;

  TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    required this.permissions,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.postCount = 0,
  });

  factory TeamMember.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TeamMember(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'member',
      avatarUrl: data['avatarUrl'],
      permissions: List<String>.from(data['permissions'] ?? ['create']),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      postCount: data['postCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'permissions': permissions,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'postCount': postCount,
    };
  }

  TeamMember copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? avatarUrl,
    List<String>? permissions,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? postCount,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      postCount: postCount ?? this.postCount,
    );
  }

  @override
  String toString() {
    return 'TeamMember(id: $id, name: $name, email: $email, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeamMember && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
