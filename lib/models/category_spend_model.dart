import '../models/transaction_model.dart';

class CategorySpend {
  final CategoryType category;
  final double totalAmount;
  final int transactionCount;
  final double percentageOfTotal;

  const CategorySpend({
    required this.category,
    required this.totalAmount,
    required this.transactionCount,
    required this.percentageOfTotal,
  });
}
