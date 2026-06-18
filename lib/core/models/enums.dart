enum CategoryType { income, expense, transfer, system }

enum ImportBatchStatus { pending, parsing, completed, failed, cancelled }

enum MatchType { contains, regex, exact, merchant }

enum RecurringStatus { detected, confirmed, rejected }

enum ReviewReason { lowConfidence, possibleDuplicate, ambiguousColumns }

enum PaymentFrequency { weekly, biweekly, monthly, quarterly, yearly, irregular }

enum AccountType { savings, creditCard, wallet, cash, investment }
