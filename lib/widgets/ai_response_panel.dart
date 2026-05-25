import 'package:flutter/material.dart';

/// Shows loading state or the AI reply text in a card-style panel.
class AiResponsePanel extends StatelessWidget {
  const AiResponsePanel({
    super.key,
    required this.isLoading,
    required this.responseText,
  });

  final bool isLoading;
  final String responseText;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.smart_toy_outlined, size: 22, color: scheme.primary),
            const SizedBox(width: 8),
            Text(
              'AI response',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? Center(
                      key: const ValueKey('loading'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: scheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Thinking about your problem…',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : responseText.isEmpty
                      ? Align(
                          key: const ValueKey('empty'),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Your answer will show up here after you submit a '
                            'problem.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  height: 1.4,
                                ),
                          ),
                        )
                      : SelectableText(
                          key: const ValueKey('text'),
                          responseText,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.45,
                              ),
                        ),
            ),
          ),
        ),
      ],
    );
  }
}
