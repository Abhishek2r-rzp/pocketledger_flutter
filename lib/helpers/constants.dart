const String appVersion = '1.0.0';
const String defaultCurrency = 'INR';
const String dataExportFileName = 'pocketledger_export';
const int agentLogRetentionDays = 90;
const int maxReviewQueueItems = 500;
const int autoCategorizationMinConfidence = 60;

const Map<String, String> categoryIcons = {
  'Food': 'restaurant',
  'Food Delivery': 'delivery_dining',
  'Groceries': 'shopping_cart',
  'Rent': 'home',
  'Bills': 'receipt',
  'Utilities': 'electrical_services',
  'Shopping': 'local_mall',
  'Travel': 'flight',
  'Transport': 'directions_bus',
  'Fuel': 'local_gas_station',
  'Entertainment': 'movie',
  'Health': 'local_hospital',
  'Investments': 'trending_up',
  'Transfers': 'swap_horiz',
  'Salary': 'account_balance',
  'Refunds': 'undo',
  'Subscriptions': 'subscriptions',
  'Fees & Charges': 'money_off',
  'Cash Withdrawal': 'currency_rupee',
  'Other': 'category',
};

const Map<String, String> builtInMerchantCategories = {
  'swiggy': 'Food Delivery',
  'zomato': 'Food Delivery',
  'zepto': 'Groceries',
  'blinkit': 'Groceries',
  'bigbasket': 'Groceries',
  'amazon': 'Shopping',
  'flipkart': 'Shopping',
  'myntra': 'Shopping',
  'nykaa': 'Shopping',
  'uber': 'Travel',
  'ola': 'Travel',
  'rapido': 'Transport',
  'indianoil': 'Fuel',
  'bpcl': 'Fuel',
  'hpc': 'Fuel',
  'netflix': 'Subscriptions',
  'prime video': 'Subscriptions',
  'hotstar': 'Subscriptions',
  'spotify': 'Subscriptions',
  'youtube premium': 'Subscriptions',
  'google one': 'Subscriptions',
  'icici': 'Bills',
  'hdfc': 'Bills',
  'sbi': 'Bills',
  'airtel': 'Bills',
  'jio': 'Bills',
  'vi': 'Bills',
};

const List<String> supportedCurrencies = [
  'INR',
  'USD',
  'EUR',
  'GBP',
  'AED',
  'SGD',
  'CAD',
  'AUD',
];

const List<String> supportedFileTypes = [
  'csv',
  'pdf',
  'xlsx',
  'tsv',
  'txt',
];
