class AuthRepository {
  Future<bool> login(String email, String password) async {
    // Mock login - always succeeds
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
