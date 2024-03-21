import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gemini/Models/msg.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const key = "AIzaSyDDkRwXHukKgh16n7BcehiRI-4rI6anQog";
  TextEditingController properties = TextEditingController();
  List<Message> chatMessage = [];
  final model = GenerativeModel(model: 'gemini-pro', apiKey: key);
  void SendMessage() async {
    chatMessage.add(
        Message(isUser: true, msg: properties.text, dateTime: DateTime.now()));
    final content = [Content.text(properties.text)];
    final response = await model.generateContent(content);
    chatMessage.add(Message(
        isUser: false, msg: response.text ?? "", dateTime: DateTime.now()));
    properties.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: chatMessage.length,
                    itemBuilder: (context, index) => BubbleNormal(
                          text: chatMessage[index].msg,
                          isSender: chatMessage[index].isUser,
                        ))),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: properties,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "num"),
                  ),
                ),
                Gap(20),
                ElevatedButton(
                    onPressed: () {
                      SendMessage();
                    },
                    child: Icon(Icons.send))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
