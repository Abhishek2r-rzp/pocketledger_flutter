import '../core/models/transaction.dart';
import 'agent_core/agent_protocol.dart';

class DedupInput {
  final List<Transaction> transactions;
  final List<Transaction> existingTransactions;

  const DedupInput({
    required this.transactions,
    required this.existingTransactions,
  });
}

class DedupOutput {
  final List<Transaction> uniqueTransactions;
  final List<Transaction> exactDuplicates;
  final List<Transaction> possibleDuplicates;

  const DedupOutput({
    required this.uniqueTransactions,
    required this.exactDuplicates,
    required this.possibleDuplicates,
  });
}

class DeduplicationAgent implements Agent<DedupInput, DedupOutput> {
  @override
  String get name => 'DeduplicationAgent';

  @override
  String get purpose =>
      'Finds exact and possible duplicates among transactions';

  List<Transaction> findExactDuplicates(
    List<Transaction> transactions,
    List<Transaction> existing,
  ) {
    final existingFingerprints = existing.map((t) => t.fingerprint).toSet();
    return transactions
        .where((t) => existingFingerprints.contains(t.fingerprint))
        .toList();
  }

  List<_DuplicatePair> _findExactDuplicatesWithin(
      List<Transaction> transactions) {
    final seen = <String, Transaction>{};
    final duplicates = <_DuplicatePair>[];

    for (final tx in transactions) {
      final existing = seen[tx.fingerprint];
      if (existing != null) {
        duplicates.add(_DuplicatePair(original: existing, duplicate: tx));
      } else {
        seen[tx.fingerprint] = tx;
      }
    }

    return duplicates;
  }

  List<Transaction> findPossibleDuplicates(
    List<Transaction> transactions,
    List<Transaction> existing,
  ) {
    final possible = <Transaction>[];

    for (final tx in transactions) {
      for (final ex in existing) {
        final amountDiff = (tx.amount - ex.amount).abs();
        final dateDiff = tx.date.difference(ex.date).abs().inDays;

        if (amountDiff <= 1.0 && dateDiff <= 3) {
          final descSimilar = _descriptionsSimilar(
              tx.description, ex.description);
          if (descSimilar) {
            possible.add(tx);
            break;
          }
        }
      }
    }

    return possible;
  }

  bool _descriptionsSimilar(String a, String b) {
    final normA = a.toLowerCase().replaceAll(RegExp(r'[^a-z0-9 ]'), '');
    final normB = b.toLowerCase().replaceAll(RegExp(r'[^a-z0-9 ]'), '');

    if (normA == normB) return true;

    final wordsA = normA.split(RegExp(r'\s+')).where((w) => w.length > 2).toList();
    final wordsB = normB.split(RegExp(r'\s+')).where((w) => w.length > 2).toList();

    if (wordsA.isEmpty || wordsB.isEmpty) return normA.contains(normB) || normB.contains(normA);

    int matches = 0;
    for (final wa in wordsA) {
      for (final wb in wordsB) {
        if (wa == wb || wa.contains(wb) || wb.contains(wa)) {
          matches++;
          break;
        }
      }
    }

    final minLen = wordsA.length < wordsB.length ? wordsA.length : wordsB.length;
    if (minLen == 0) return false;
    return matches / minLen >= 0.5;
  }

  @override
  Future<AgentResult<DedupOutput>> run(DedupInput input) async {
    try {
      final withinNew = _findExactDuplicatesWithin(input.transactions);
      final internalExact = withinNew.map((p) => p.duplicate).toList();

      final uniqueWithin = input.transactions
          .where((t) => !internalExact.contains(t))
          .toList();

      final exactWithExisting = findExactDuplicates(
          uniqueWithin, input.existingTransactions);

      final exactDuplicates = [
        ...internalExact,
        ...exactWithExisting,
      ];

      final afterExact = uniqueWithin
          .where((t) => !exactWithExisting.contains(t))
          .toList();

      final possibleDuplicates = findPossibleDuplicates(
          afterExact, input.existingTransactions);

      final uniqueTransactions = afterExact
          .where((t) => !possibleDuplicates.contains(t))
          .toList();

      return AgentResult(
        status: AgentTaskStatus.completed,
        output: DedupOutput(
          uniqueTransactions: uniqueTransactions,
          exactDuplicates: exactDuplicates,
          possibleDuplicates: possibleDuplicates,
        ),
        confidence: exactDuplicates.isEmpty && possibleDuplicates.isEmpty
            ? 1.0
            : 0.9,
        explanation:
            'Found ${exactDuplicates.length} exact and ${possibleDuplicates.length} possible duplicates, keeping ${uniqueTransactions.length} unique',
      );
    } catch (e) {
      return AgentResult(
        status: AgentTaskStatus.failed,
        confidence: 0,
        explanation: 'Deduplication error: $e',
      );
    }
  }
}

class _DuplicatePair {
  final Transaction original;
  final Transaction duplicate;
  const _DuplicatePair({
    required this.original,
    required this.duplicate,
  });
}
