import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LlmChatView(
        provider: GeminiProvider(
          model: GenerativeModel(
            model: 'gemini-2.0-flash',
            apiKey:
                'AIzaSyBCe315zyhyhcBQ-8xAKGsaDnWQV60RZfg', // Replace with your actual API key or import from secrets
          ),
        ),
      ),
    );
  }
}
