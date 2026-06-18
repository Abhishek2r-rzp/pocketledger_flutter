import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/data_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = DataRepository();
  runApp(
    ProviderScope(
      overrides: [
        dataRepositoryProvider.overrideWithValue(repo),
      ],
      child: const PocketLedgerApp(),
    ),
  );
}
