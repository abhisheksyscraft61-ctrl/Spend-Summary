# SpendTrack – Spend Summary App

A beautiful Flutter app for tracking monthly expenses with a clean dark-mode UI.

---

## 📱 Features

- **Header Card** – Monthly spend with % change vs last month + budget progress
- **Quick Stats Row** – Average daily spend, largest transaction, total count
- **Category Scroll** – 8 categories (Food, Travel, Shopping, Health, Entertainment, Bills, Education, Others) with icons, amounts, and tap-to-filter
- **57 Transactions** – Complete mock dataset with tap to view details
- **Add Expense FAB** – Bottom sheet with amount, title, and category picker
- **Profile Screen** – User info, stats, and settings
- **Smooth Animations** – Shimmer loading, slide-in entries, fade effects

---

## 📸 Screenshots

> Tested on Android Emulator — June 2025

<p align="center">
  <img src="screenshots/home_screen.png" width="30%" alt="Home Screen"/>
  &nbsp;&nbsp;
  <img src="screenshots/profile_screen.png" width="30%" alt="Profile Screen"/>
  &nbsp;&nbsp;
  <img src="screenshots/add_expense.png" width="30%" alt="Add Expense"/>
</p>

<p align="center">
  <img src="screenshots/filter_transactions.png" width="30%" alt="Filter Transactions"/>
  &nbsp;&nbsp;
  <img src="screenshots/transaction_detail.png" width="30%" alt="Transaction Detail"/>
</p>

<p align="center">
  <b>Home</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <b>Profile</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <b>Add Expense</b>
</p>

<p align="center">
  <b>Filter Transactions</b> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <b>Transaction Detail</b>
</p>

---

## 🗂 Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/        # Colors, text styles, sizes
│   ├── theme/            # AppTheme
│   ├── utils/            # CurrencyFormatter, DateFormatter
│   └── services/         # MockDataService (57 transactions)
├── models/
│   ├── transaction_model.dart
│   ├── category_spend_model.dart
│   └── user_model.dart
├── providers/
│   ├── auth_provider.dart
│   ├── user_provider.dart
│   └── spend_provider.dart
├── screens/
│   ├── auth/login_screen.dart
│   ├── home/home_screen.dart
│   └── profile/profile_screen.dart
├── widgets/
│   ├── spend_header_card.dart
│   ├── category_scroll_section.png
│   ├── transaction_tile.dart
│   ├── transaction_list_section.dart
│   ├── add_expense_sheet.dart
│   ├── loading_widget.dart
│   ├── custom_button.dart
│   └── custom_textfield.dart
├── repositories/
│   ├── auth_repository.dart
│   └── product_repository.dart
└── routes/
    └── app_routes.dart
```

---

## 🚀 Getting Started

```bash
# Install dependencies
flutter pub get

# Run on emulator or device
flutter run
```

**Minimum SDK:** Flutter 3.41.1, Dart 3.11.0  
**Target:** Android / iOS

---

## 📦 Dependencies

| Package | Use |
|---|---|
| `provider` | State management |
| `google_fonts` | Poppins + Inter typography |
| `flutter_animate` | Smooth entry animations |
| `shimmer` | Loading skeleton |
| `fl_chart` | Available for future chart widget |
| `intl` | Currency & date formatting |

---

*Built with ❤️ using Flutter*
