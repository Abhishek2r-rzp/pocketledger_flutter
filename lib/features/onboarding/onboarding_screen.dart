import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketledger/features/onboarding/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(onboardingPageProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) =>
                    ref.read(onboardingPageProvider.notifier).setPage(index),
                itemBuilder: (context, index) {
                  return _OnboardingPage(
                    icon: _pages[index].icon,
                    title: _pages[index].title,
                    description: _pages[index].description,
                    color: _pages[index].color,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: page == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: page == i
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    if (page < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      ref.read(onboardingCompletedProvider.notifier).complete();
                      context.go('/lock');
                    }
                  },
                  child: Text(
                    page < _pages.length - 1 ? 'Next' : 'Get Started',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 56, color: color),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

final _pages = [
  _PageData(
    icon: Icons.security,
    title: 'Your Data Stays on iPhone',
    description: 'PocketLedger processes everything locally on your device. Your financial data never leaves your phone. No servers, no cloud, no tracking.',
    color: const Color(0xFF00897B),
  ),
  _PageData(
    icon: Icons.upload_file,
    title: 'Import Bank Statements',
    description: 'Import CSV and PDF bank statements effortlessly. PocketLedger automatically parses Indian bank formats from HDFC, ICICI, SBI, and more.',
    color: const Color(0xFF1565C0),
  ),
  _PageData(
    icon: Icons.auto_awesome,
    title: 'Smart Categorization',
    description: 'AI-powered agent automatically categorizes your transactions. Review suggestions, set budgets, and track spending patterns - all offline.',
    color: const Color(0xFF7B1FA2),
  ),
];

class _PageData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _PageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
