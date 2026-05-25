import 'package:flutter/material.dart';

import '../../models/dsa_topic.dart';
import '../../services/ai_service.dart';
import '../../widgets/ai_response_panel.dart';
import '../../widgets/dsa_topic_dropdown.dart';

/// DSA practice: pick a topic, describe a problem, get a Gemini reply.
class DSAPracticeScreen extends StatefulWidget {
  const DSAPracticeScreen({super.key});

  @override
  State<DSAPracticeScreen> createState() => _DSAPracticeScreenState();
}

class _DSAPracticeScreenState extends State<DSAPracticeScreen> {
  final TextEditingController _questionController = TextEditingController();
  final AiService _aiService = AiService();

  DsaTopic _topic = DsaTopic.arrays;
  bool _isLoading = false;
  String _responseText = '';

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Block extra taps while a request is already in flight.
    if (_isLoading) return;

    // 1. Read the user's question from the text field.
    final String question = _questionController.text.trim();
    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your question or problem.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    // 2. Show loading spinner and clear any old answer.
    setState(() {
      _isLoading = true;
      _responseText = '';
    });

    // Build a prompt that tells Gemini the DSA topic and the problem.
    final String prompt =
        'DSA topic: ${_topic.label}\n\n'
        'Problem:\n$question\n\n'
        'Explain the approach, edge cases, time and space complexity, '
        'and a clear solution outline.';

    try {
      // 3. Call Gemini and wait for the answer.
      final String answer = await _aiService.getAIResponse(prompt);

      if (!mounted) return;

      // 4. Hide spinner and show the AI text below.
      setState(() {
        _isLoading = false;
        _responseText = answer;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DSA Practice'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Describe a problem',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Pick a topic and paste or type your question. Submit to get '
                'help from Gemini.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.35,
                    ),
              ),
              const SizedBox(height: 24),
              DsaTopicDropdown(
                selectedTopic: _topic,
                onTopicChanged: (t) => setState(() => _topic = t),
              ),
              const SizedBox(height: 20),
              Text(
                'Your question / problem',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _questionController,
                minLines: 5,
                maxLines: 10,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText:
                      'Example: Given an array of integers, find two numbers '
                      'that add up to a target…',
                  alignLabelWithHint: true,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _isLoading ? null : _submit,
                icon: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 20),
                label: Text(_isLoading ? 'Please wait…' : 'Submit'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 28),
              AiResponsePanel(
                isLoading: _isLoading,
                responseText: _responseText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
