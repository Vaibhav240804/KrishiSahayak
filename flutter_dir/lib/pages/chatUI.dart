import 'package:flutter/material.dart';
import 'package:krishi_sahayak/providers/providers.dart';
import 'package:krishi_sahayak/providers/user_provider.dart';
import 'package:krishi_sahayak/providers/weather_provider.dart';
import 'package:provider/provider.dart';

class ChatUI extends StatefulWidget {
  const ChatUI({Key? key}) : super(key: key);

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final chatProvider = Provider.of<ChatProvider>(context);
    final location = Provider.of<UserProvider>(context).user.city;
    final weather =
        Provider.of<WeatherProvider>(context).currentWeather.toString();
    final soilAnalysis =
        Provider.of<UserProvider>(context).user.soil.toString();
    final weatherForecast =
        Provider.of<WeatherProvider>(context).foreCast.toString();
    final locale = Provider.of<LocaleProvider>(context).locale;

    void sendMessage() {
      final text = _textController.text;
      chatProvider.messages.add([0, text]);
      if (text.isNotEmpty) {
        chatProvider.setDetails(
            location, weather, "", soilAnalysis, weatherForecast);
        chatProvider.fetchLlmResponse(text, locale.languageCode);
        _textController.clear();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Krishi Sahayak Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: false,
                itemCount: chatProvider.messages.length,
                itemBuilder: (context, index) {
                  final message = chatProvider.messages[index];
                  final isUser = message[0] == 0;

                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: isUser ? Alignment.topRight : Alignment.topLeft,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color:
                            isUser ? Colors.lightBlueAccent : Colors.grey[200],
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Text(message[1], textAlign: TextAlign.justify),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
