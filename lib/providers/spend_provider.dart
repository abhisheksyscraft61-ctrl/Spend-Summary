import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/category_spend_model.dart';
import '../core/services/mock_data_service.dart';

class SpendProvider extends ChangeNotifier {
  List<TransactionModel> _allTransactions = [];
  CategoryType? _selectedCategory;
  bool _isLoading = false;

  List<TransactionModel> get allTransactions => _allTransactions;
  CategoryType? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  double get currentMonthSpend => MockDataService.currentMonthSpend;
  double get lastMonthSpend => MockDataService.lastMonthSpend;
  double get percentChange => MockDataService.percentChange;
  bool get isIncreased => percentChange > 0;

  List<TransactionModel> get filteredTransactions {
    if (_selectedCategory == null) return _allTransactions;
    return _allTransactions
        .where((t) => t.category == _selectedCategory)
        .toList();
  }

  List<CategorySpend> get categorySpends {
    final total = _allTransactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);

    return CategoryType.values.map((cat) {
      final catTransactions =
          _allTransactions.where((t) => t.category == cat).toList();
      final catTotal =
          catTransactions.fold(0.0, (sum, t) => sum + t.amount);
      return CategorySpend(
        category: cat,
        totalAmount: catTotal,
        transactionCount: catTransactions.length,
        percentageOfTotal: total > 0 ? (catTotal / total) * 100 : 0,
      );
    }).toList()
      ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    _allTransactions = MockDataService.allTransactions;
    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(CategoryType? category) {
    _selectedCategory = category == _selectedCategory ? null : category;
    notifyListeners();
  }

  void clearFilter() {
    _selectedCategory = null;
    notifyListeners();
  }
}
