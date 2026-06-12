import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum TransactionType { expense, income }

enum CategoryType {
  food,
  travel,
  shopping,
  health,
  entertainment,
  bills,
  education,
  others,
}

extension CategoryExtension on CategoryType {
  String get label {
    switch (this) {
      case CategoryType.food:
        return 'Food';
      case CategoryType.travel:
        return 'Travel';
      case CategoryType.shopping:
        return 'Shopping';
      case CategoryType.health:
        return 'Health';
      case CategoryType.entertainment:
        return 'Entertainment';
      case CategoryType.bills:
        return 'Bills';
      case CategoryType.education:
        return 'Education';
      case CategoryType.others:
        return 'Others';
    }
  }

  IconData get icon {
    switch (this) {
      case CategoryType.food:
        return Icons.restaurant_rounded;
      case CategoryType.travel:
        return Icons.flight_rounded;
      case CategoryType.shopping:
        return Icons.shopping_bag_rounded;
      case CategoryType.health:
        return Icons.favorite_rounded;
      case CategoryType.entertainment:
        return Icons.movie_rounded;
      case CategoryType.bills:
        return Icons.receipt_long_rounded;
      case CategoryType.education:
        return Icons.school_rounded;
      case CategoryType.others:
        return Icons.more_horiz_rounded;
    }
  }

  Color get color {
    switch (this) {
      case CategoryType.food:
        return AppColors.catFood;
      case CategoryType.travel:
        return AppColors.catTravel;
      case CategoryType.shopping:
        return AppColors.catShopping;
      case CategoryType.health:
        return AppColors.catHealth;
      case CategoryType.entertainment:
        return AppColors.catEntertainment;
      case CategoryType.bills:
        return AppColors.catBills;
      case CategoryType.education:
        return AppColors.catEducation;
      case CategoryType.others:
        return AppColors.catOthers;
    }
  }
}

class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final TransactionType type;
  final CategoryType category;
  final DateTime date;
  final String? note;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
  });

  bool get isExpense => type == TransactionType.expense;
}
