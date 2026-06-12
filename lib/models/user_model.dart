class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final double monthlyBudget;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.monthlyBudget,
  });

  String get firstName => name.split(' ').first;
}
