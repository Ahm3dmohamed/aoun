import 'package:aoun/core/storage/auth_local_data_source.dart';

enum UserRole {
  donor,
  foundationAdmin,
}

class HomeRoleResolver {
  final AuthLocalDataSource authLocalDataSource;

  const HomeRoleResolver(this.authLocalDataSource);

  Future<UserRole> resolveRole() async {
    final userData = await authLocalDataSource.getUserData();
    final role = userData?['role']?.toString();
    if (role == 'foundation_admin') {
      return UserRole.foundationAdmin;
    }
    return UserRole.donor;
  }

  Future<String?> getUserEmail() async {
    final userData = await authLocalDataSource.getUserData();
    return userData?['email']?.toString();
  }

  Future<String?> getUserName() async {
    final userData = await authLocalDataSource.getUserData();
    return userData?['name']?.toString();
  }
}
