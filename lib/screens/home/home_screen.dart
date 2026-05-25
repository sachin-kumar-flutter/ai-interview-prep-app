import 'package:flutter/material.dart';

import '../../widgets/feature_card.dart';
import '../dsa_practice/dsa_practice_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FeatureItem> features = [
      const FeatureItem(
        title: 'DSA Practice',
        subtitle: 'Sharpen your problem solving skills',
        icon: Icons.code_rounded,
      ),
      const FeatureItem(
        title: 'AI Code Reviewer',
        subtitle: 'Get instant feedback on your code',
        icon: Icons.auto_awesome_rounded,
      ),
      const FeatureItem(
        title: 'Resume Analyzer',
        subtitle: 'Improve your resume for interviews',
        icon: Icons.description_rounded,
      ),
      const FeatureItem(
        title: 'Progress Dashboard',
        subtitle: 'Track growth and consistency',
        icon: Icons.insights_rounded,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Interview Prep'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Pick a feature to continue your prep.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final int crossAxisCount = _getCrossAxisCount(
                      constraints.maxWidth,
                    );

                    return GridView.builder(
                      itemCount: features.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final feature = features[index];

                        return FeatureCard(
                          item: feature,
                          onTap: () => _onFeatureTap(context, feature.title),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width >= 1100) return 4;
    if (width >= 800) return 3;
    if (width >= 560) return 2;
    return 1;
  }

  void _onFeatureTap(BuildContext context, String featureName) {
    if (featureName == 'DSA Practice') {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const DSAPracticeScreen(),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => PlaceholderScreen(title: featureName),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title screen coming soon.',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
