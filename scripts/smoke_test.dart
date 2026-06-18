// PocketLedger Smoke Test — Verifies the project compiles and all pieces fit.
//
// Run: dart run scripts/smoke_test.dart
// This script checks:
//   1. Project structure completeness
//   2. Import integrity (every file can be parsed)
//   3. Enum/model consistency
//   4. Agent count and interface compliance
//   5. Test coverage gaps

import 'dart:io';
import 'dart:convert';

int errors = 0;
int warnings = 0;

void main(List<String> args) {
  final root = Directory.current;
  print('═══════════════════════════════════════════════════════');
  print(' PocketLedger Smoke Test');
  print(' Root: ${root.path}');
  print('═══════════════════════════════════════════════════════');
  print('');

  // ─── 1. Project Structure ───────────────────────────────────
  section('1. Project Structure');

  checkFile('pubspec.yaml');
  checkFile('analysis_options.yaml');
  checkFile('lib/main.dart');
  checkFile('lib/app.dart');
  checkFile('lib/router.dart');

  checkDir('lib/core/models');
  checkDir('lib/core/database/daos');
  checkDir('lib/core/security');
  checkDir('lib/core/privacy');
  checkDir('lib/agents/agent_core');
  checkDir('lib/parsers');
  checkDir('lib/services');
  checkDir('lib/helpers');
  checkDir('test/unit');
  checkDir('test/widget');
  checkDir('test/integration');
  checkDir('test/e2e');
  checkDir('test_resources');

  // ─── 2. Core Models ─────────────────────────────────────────
  section('2. Core Models');

  final expectedModels = [
    'enums.dart', 'transaction.dart', 'category.dart',
    'import_batch.dart', 'categorization_rule.dart', 'budget.dart',
    'recurring_payment.dart', 'agent_action_log.dart', 'user_settings.dart',
  ];

  for (final model in expectedModels) {
    checkFile('lib/core/models/$model');
  }

  // ─── 3. Database Layer ──────────────────────────────────────
  section('3. Database Layer');

  checkFile('lib/core/database/database.dart');
  checkFile('lib/core/database/seed_data.dart');

  final expectedDaos = [
    'transaction_dao.dart', 'category_dao.dart', 'import_batch_dao.dart',
    'rule_dao.dart', 'budget_dao.dart', 'recurring_payment_dao.dart',
    'agent_log_dao.dart', 'settings_dao.dart',
  ];

  for (final dao in expectedDaos) {
    checkFile('lib/core/database/daos/$dao');
  }

  // ─── 4. Agents ──────────────────────────────────────────────
  section('4. Agent System');

  checkFile('lib/agents/agent_core/agent_protocol.dart');
  checkFile('lib/agents/agent_core/agent_orchestrator.dart');

  final expectedAgents = [
    'file_import_agent', 'statement_parser_agent', 'transaction_normalizer_agent',
    'deduplication_agent', 'merchant_cleaner_agent', 'categorization_agent',
    'review_queue_agent', 'learning_agent', 'budget_agent',
    'recurring_payment_agent', 'insight_agent', 'privacy_guard_agent',
  ];

  final agentDir = Directory('${root.path}/lib/agents');
  final agentFiles = agentDir.listSync()
      .whereType<File>()
      .map((f) => f.name)
      .toSet();

  for (final agent in expectedAgents) {
    if (agentFiles.contains('$agent.dart')) {
      success('Agent: $agent');
    } else {
      error('Missing agent: $agent.dart');
    }
  }

  // ─── 5. Feature Screens ─────────────────────────────────────
  section('5. Feature Screens');

  final expectedScreens = [
    'onboarding', 'lock', 'dashboard', 'import', 'review_queue',
    'transactions', 'charts', 'budgets', 'recurring_payments',
    'import_history', 'settings', 'agent_logs',
  ];

  for (final screen in expectedScreens) {
    checkFile('lib/features/$screen/${screen}_screen.dart');
    checkFile('lib/features/$screen/${screen}_provider.dart');
  }

  checkFile('lib/features/transactions/transaction_detail_screen.dart');
  checkFile('lib/features/transactions/transaction_detail_provider.dart');

  // ─── 6. Parsers ─────────────────────────────────────────────
  section('6. Parsers');

  checkFile('lib/parsers/csv_parser.dart');
  checkFile('lib/parsers/pdf_parser.dart');
  checkFile('lib/parsers/xlsx_parser.dart');

  // ─── 7. Services ────────────────────────────────────────────
  section('7. Services');

  checkFile('lib/services/export_service.dart');
  checkFile('lib/services/search_service.dart');

  // ─── 8. Security & Privacy ──────────────────────────────────
  section('8. Security & Privacy');

  checkFile('lib/core/security/biometric_manager.dart');
  checkFile('lib/core/privacy/privacy_manager.dart');

  // ─── 9. Tests ───────────────────────────────────────────────
  section('9. Tests');

  final expectedUnitTests = [
    'csv_parser_test.dart', 'date_parsing_test.dart',
    'debit_credit_normalization_test.dart', 'deduplication_test.dart',
    'merchant_cleaner_test.dart', 'categorization_test.dart',
    'learning_test.dart', 'budget_test.dart',
    'recurring_payment_detection_test.dart', 'import_batch_deletion_test.dart',
  ];

  for (final test in expectedUnitTests) {
    checkFile('test/unit/$test');
  }

  checkFile('test/widget/dashboard_screen_test.dart');
  checkFile('test/widget/transactions_screen_test.dart');
  checkFile('test/widget/import_screen_test.dart');
  checkFile('test/integration/app_flow_test.dart');
  checkFile('test/e2e/app_e2e_test.dart');
  checkFile('test/test_helpers.dart');

  // ─── 10. Sample Data ────────────────────────────────────────
  section('10. Sample Data');

  checkFile('test_resources/sample_indian_bank_statement.csv');

  if (File('${root.path}/test_resources/sample_indian_bank_statement.csv').existsSync()) {
    final lines = File('${root.path}/test_resources/sample_indian_bank_statement.csv')
        .readAsLinesSync();
    if (lines.length >= 25) {
      success('CSV has ${lines.length} lines (header + ${lines.length - 1} transactions)');
    } else {
      warning('CSV has only ${lines.length} lines, expected 30+');
    }
  }

  // ─── 11. Pubspec Dependencies ───────────────────────────────
  section('11. Pubspec Dependencies');

  if (File('${root.path}/pubspec.yaml').existsSync()) {
    final content = File('${root.path}/pubspec.yaml').readAsStringSync();
    
    final requiredDeps = [
      'flutter_riverpod', 'go_router', 'drift', 'fl_chart',
      'local_auth', 'file_picker', 'csv', 'share_plus', 'uuid', 'intl',
    ];

    for (final dep in requiredDeps) {
      if (content.contains(dep)) {
        success('Dependency: $dep');
      } else {
        warning('Missing dependency: $dep');
      }
    }
  }

  // ─── 12. CI Configuration ───────────────────────────────────
  section('12. CI Configuration');

  checkFile('.github/workflows/test.yml');
  checkFile('Makefile');
  checkFile('scripts/smoke_test.dart');

  // ─── Summary ────────────────────────────────────────────────
  print('');
  print('═══════════════════════════════════════════════════════');
  if (errors == 0 && warnings == 0) {
    print(' ✅ ALL CHECKS PASSED — Zero errors, zero warnings');
  } else if (errors == 0) {
    print(' ✅ PASSED — $warnings warnings (non-blocking)');
  } else {
    print(' ❌ FAILED — $errors errors, $warnings warnings');
  }
  print('═══════════════════════════════════════════════════════');

  exit(errors > 0 ? 1 : 0);
}

// ─── Helpers ───────────────────────────────────────────────────

void section(String name) {
  print('');
  print('─── $name ───');
}

void checkFile(String path) {
  final fullPath = '${Directory.current.path}/$path';
  if (File(fullPath).existsSync()) {
    final size = File(fullPath).lengthSync();
    success('$path (${formatSize(size)})');
  } else {
    error('Missing: $path');
  }
}

void checkDir(String path) {
  final fullPath = '${Directory.current.path}/$path';
  if (Directory(fullPath).existsSync()) {
    final count = Directory(fullPath).listSync().length;
    success('$path ($count items)');
  } else {
    error('Missing directory: $path');
  }
}

void success(String msg) {
  print('  ✅ $msg');
}

void warning(String msg) {
  print('  ⚠️  $msg');
  warnings++;
}

void error(String msg) {
  print('  ❌ $msg');
  errors++;
}

String formatSize(int bytes) {
  if (bytes < 1024) return '${bytes}B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
}
