import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketledger/features/import/import_provider.dart';

class ImportScreen extends ConsumerWidget {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Statement'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: state is! ImportProcessing ? () => _pickFile(ref) : null,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.3),
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select Bank Statement',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'CSV or PDF format',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state is ImportProcessing) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Processing ${state.fileName}...',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Parsing transactions',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (state is ImportNeedsPassword) ...[
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: PasswordPrompt(
                    fileName: state.fileName,
                    fileType: state.fileType,
                    message: state.message,
                    onSubmit: (password) => ref
                        .read(importProvider.notifier)
                        .processPdfWithPassword(password),
                  ),
                ),
              ),
            ],
            if (state is ImportPreview) ...[
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _SummaryRow('Total transactions',
                        state.totalCount.toString(), Icons.receipt, theme),
                    _SummaryRow(
                        'New transactions',
                        state.newCount.toString(),
                        Icons.add_circle_outline,
                        iconColor: const Color(0xFF4CAF50),
                        theme),
                    _SummaryRow(
                        'Duplicates',
                        state.duplicateCount.toString(),
                        Icons.content_copy,
                        iconColor: const Color(0xFFF44336),
                        theme),
                    _SummaryRow(
                        'Needs review',
                        state.needsReviewCount.toString(),
                        Icons.rate_review,
                        iconColor: const Color(0xFFFF9800),
                        theme),
                    const SizedBox(height: 16),
                    if (state.categoryDistribution.isNotEmpty) ...[
                      Text('Category Distribution',
                          style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      ...state.categoryDistribution.entries.map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(e.key,
                                        style: theme.textTheme.bodySmall)),
                                Text('${e.value}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          )),
                    ],
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          ref.read(importProvider.notifier).cancel(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        await ref.read(importProvider.notifier).confirm();
                        if (context.mounted) context.go('/');
                      },
                      child: const Text('Confirm Import'),
                    ),
                  ),
                ],
              ),
            ],
            if (state is ImportError) ...[
              const SizedBox(height: 24),
              Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: theme.colorScheme.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.message,
                          style: TextStyle(
                              color: theme.colorScheme.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.read(importProvider.notifier).reset(),
                child: const Text('Try Again'),
              ),
            ],
            if (state is ImportIdle) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Supported Formats',
                          style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      _FormatRow('CSV', 'Comma-separated values from any bank',
                          Icons.description, theme),
                      _FormatRow('PDF', 'Bank statements in PDF format',
                          Icons.picture_as_pdf, theme),
                      _FormatRow('XLSX', 'Coming soon - convert to CSV for now',
                          Icons.table_chart, theme),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile(WidgetRef ref) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final name = result.files.single.name;
      ref.read(importProvider.notifier).processFile(path, name);
    }
  }
}

class _FormatRow extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final ThemeData theme;

  const _FormatRow(this.title, this.description, this.icon, this.theme);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
                Text(description, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final ThemeData theme;

  _SummaryRow(this.label, this.value, this.icon, this.theme, {this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon,
              size: 20,
              color: iconColor ?? theme.colorScheme.onSurface.withOpacity(0.6)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class PasswordPrompt extends StatefulWidget {
  final String fileName;
  final String fileType;
  final String? message;
  final ValueChanged<String> onSubmit;

  const PasswordPrompt({
    super.key,
    required this.fileName,
    required this.fileType,
    this.message,
    required this.onSubmit,
  });

  @override
  State<PasswordPrompt> createState() => _PasswordPromptState();
}

class _PasswordPromptState extends State<PasswordPrompt> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = widget.fileType.toUpperCase();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.lock_outline,
                size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Password Protected $label',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              widget.fileName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            if (widget.message != null) ...[
              Text(
                widget.message!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _controller,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Enter $label password',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.key),
              ),
              autofocus: true,
              onSubmitted: (v) {
                if (v.isNotEmpty) widget.onSubmit(v);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    widget.onSubmit(_controller.text);
                  }
                },
                icon: const Icon(Icons.lock_open),
                label: const Text('Unlock & Parse'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
