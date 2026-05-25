import 'package:flutter/material.dart';

import '../models/dsa_topic.dart';

/// Material 3 topic picker for DSA categories.
class DsaTopicDropdown extends StatelessWidget {
  const DsaTopicDropdown({
    super.key,
    required this.selectedTopic,
    required this.onTopicChanged,
  });

  final DsaTopic selectedTopic;
  final ValueChanged<DsaTopic> onTopicChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topic',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        DropdownMenu<DsaTopic>(
          width: double.infinity,
          initialSelection: selectedTopic,
          label: const Text('Select a topic'),
          onSelected: (topic) {
            if (topic != null) onTopicChanged(topic);
          },
          dropdownMenuEntries: DsaTopic.values
              .map(
                (t) => DropdownMenuEntry<DsaTopic>(
                  value: t,
                  label: t.label,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
