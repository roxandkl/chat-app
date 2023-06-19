import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Homeapp(),
  ));
}


class Homeapp extends StatelessWidget {
  const Homeapp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        child: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatApp()),
                  );
                },
                child: Text('Hackathon',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Alumni',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Night of Science',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ChatApp extends StatefulWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  late ChatLogger chatLogger;

  TextEditingController _controller = TextEditingController();
  List<String> chatMessages = [];

  @override
  void initState() {
    super.initState();
    initChatLogger();
  }

  Future<void> initChatLogger() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${appDocumentsDirectory.path}/myFile7.csv';
    print(filePath);
    chatLogger = ChatLogger(filePath: filePath);
    List<String> lines = await chatLogger.retrieveAllLines();
    setState(() {
      chatMessages = lines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('Level-App Hackathon'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add your settings icon functionality here
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 30.0),
        child: Container(
          height: double.infinity, // Set height to fill available space
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    String message = chatMessages[index];
                    List<String> parts = message.split(',');
                    if (parts.length >= 2) {
                      String username = parts[0];
                      String content = parts[1];

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(username[0]),
                        ),
                        title: Text(username),
                        subtitle: Text(content),
                      );
                    }
                    return Container(); // Return an empty container if the message is invalid
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        String content = _controller.text;
                        await chatLogger.log(content);

                        List<String> lines = await chatLogger.retrieveAllLines();
                        setState(() {
                          chatMessages = lines;
                        });
                        _controller.clear();
                      },
                      child: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatLogger {
  final String filePath;

  ChatLogger({required this.filePath});

  Future<void> log(String message) async {
    try {
      File file = File(filePath);
      IOSink sink = file.openWrite(mode: FileMode.append);
      sink.write('s12345 , $message\n');
      print('$message');
      await sink.flush();
      await sink.close();
    } catch (e) {
      print('Error logging message: $e');
    }
  }

  Future<List<String>> retrieveAllLines() async {
    List<String> allLines = [];
    try {
      File file = File(filePath);
      Stream<String> lines = file.openRead().transform(utf8.decoder).transform(LineSplitter());
      await for (String line in lines) {
        allLines.add(line);
      }
    } catch (e) {
      print('Error retrieving lines: $e');
    }
    return allLines;
  }
}



