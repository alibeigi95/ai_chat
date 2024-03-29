import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  ChatUser myself = ChatUser(id: '1', firstName: 'Beigi');
  ChatUser bot = ChatUser(id: '2', firstName: 'Ai');
  List<ChatMessage> allMassages = [];
  final url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDb21IxZRwIHycdZ_SMCKLfhYCh5T6pprU";
  final header = {"Content-Type": "application/json"};

  getData(ChatMessage m) async {
    allMassages.insert(0, m);
    setState(() {});
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };
    await http
        .post(Uri.parse(url), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(result["candidates"][0]["content"]["parts"][0]["text"]);
        ChatMessage m1 = ChatMessage(
          user: bot,
          createdAt: DateTime.now(),
          text: result["candidates"][0]["content"]["parts"][0]["text"],
        );
        allMassages.insert(0, m1);
        setState(() {

        });
      } else {
        print('error ');
      }
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.blueGrey[100],
    appBar: AppBar(title: const Text('Ai chat'),
    backgroundColor: Colors.cyan[300],),
        body: DashChat(

          currentUser: myself,
          onSend: (ChatMessage m) {
            getData(m);
          },
          messages: allMassages,
        ),
      );
}

/*
AIzaSyDb21IxZRwIHycdZ_SMCKLfhYCh5T6pprU
curl \
-H 'Content-Type: application/json' \
-d '{"contents":[{"parts":[{"text":"Write a story about a magic backpack"}]}]}' \
-X POST 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=YOUR_API_KEY'
AIzaSyC-VIGN1LvWFlJHw5NeKkzTVxlWw6tBOQ4*/
