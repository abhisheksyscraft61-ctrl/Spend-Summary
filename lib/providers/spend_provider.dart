import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/category_spend_model.dart';
import '../core/services/mock_data_service.dart';

class SpendProvider extends ChangeNotifier {
  List<TransactionModel> _allTransactions = [];
  CategoryType? _selectedCategory;
  bool _isLoading = false;

  // ── Filter state ───────────────────────────────────────────────────────────
  String activeSort = 'latest';
  String activeType = 'all';
  DateTimeRange? activeDateRange;

  // ── Getters ────────────────────────────────────────────────────────────────
  List<TransactionModel> get allTransactions => _allTransactions;
  CategoryType? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  double get currentMonthSpend => MockDataService.currentMonthSpend;
  double get lastMonthSpend    => MockDataService.lastMonthSpend;
  double get percentChange     => MockDataService.percentChange;
  bool   get isIncreased       => percentChange > 0;

  bool get hasActiveFilter =>
      activeSort != 'latest' ||
          activeType != 'all'    ||
          activeDateRange != null;

  // ── filteredTransactions ───────────────────────────────────────────────────
  List<TransactionModel> get filteredTransactions {
    List<TransactionModel> result = List.from(_allTransactions);

    // 1. Category filter
    if (_selectedCategory != null) {
      result = result.where((t) => t.category == _selectedCategory).toList();
    }

    // 2. Type filter
    if (activeType == 'expense') {
      result = result.where((t) => t.isExpense).toList();
    } else if (activeType == 'income') {
      result = result.where((t) => !t.isExpense).toList();
    }

    // 3. Date range filter
    if (activeDateRange != null) {
      final start = DateTime(activeDateRange!.start.year,
          activeDateRange!.start.month, activeDateRange!.start.day);
      final end = DateTime(activeDateRange!.end.year,
          activeDateRange!.end.month, activeDateRange!.end.day, 23, 59, 59);
      result = result
          .where((t) =>
      t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
          t.date.isBefore(end.add(const Duration(seconds: 1))))
          .toList();
    }

    // 4. Sort
    switch (activeSort) {
      case 'oldest':
        result.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'highest':
        result.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'lowest':
        result.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case 'latest':
      default:
        result.sort((a, b) => b.date.compareTo(a.date));
        break;
    }

    return result;
  }

  // ── categorySpends ─────────────────────────────────────────────────────────
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

  // ── Methods ────────────────────────────────────────────────────────────────
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _allTransactions = MockDataService.allTransactions;
    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(CategoryType? category) {
    _selectedCategory = category == _selectedCategory ? null : category;
    notifyListeners();
  }

  void applyFilter({
    required String sort,
    required String type,
    DateTimeRange? dateRange,
  }) {
    activeSort      = sort;
    activeType      = type;
    activeDateRange = dateRange;
    notifyListeners();
  }

  // clearFilter — category + sort/type/date sab reset
  void clearFilter() {
    _selectedCategory = null;
    activeSort        = 'latest';
    activeType        = 'all';
    activeDateRange   = null;
    notifyListeners();
  }
}