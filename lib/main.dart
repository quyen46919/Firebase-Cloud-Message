import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'models/message_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyByP16D22Iq3icMqxi0VFCpPAYMXxobXCU',
      appId: '1:772089746769:android:c3ddffbab70cdfb3ccef70',
      messagingSenderId: '772089746769',
      projectId: 'push-notification-b06b8',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Firebase Cloud Messages'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late List <MessageModel> _messageList = [];

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getToken().then((value) => print("token is: $value"));
    FirebaseMessaging.onMessage.listen((event) {
      setState(() {
        _messageList.add(MessageModel(title: event.notification?.title, message: event.notification?.body));
        // print(event.notification);
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        _messageList.add(MessageModel(title: event.notification?.title, message: event.notification?.body));
        // print(event.notification);
      });
    });
  }

  void deleteMessage(index) {
    print(index);
    setState(() {
      _messageList.removeWhere((message) => message == _messageList[index]);
    });
  }
  void deleteAllMessages() {
    setState(() {
      _messageList = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: _messageList.asMap().entries.map((e) =>
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _messageList[e.key].title.toString(),
                      style: const TextStyle(
                          fontSize: 18.0
                      ),
                    ),
                    Text(
                      _messageList[e.key].message.toString(),
                      style: const TextStyle(
                          fontSize: 18.0
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        deleteMessage(e.key);
                      },
                      child: const Text(
                        'Xóa tin nhắn',
                        style: TextStyle(
                            fontSize: 18.0
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )).toList()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          deleteAllMessages();
        },
        tooltip: 'Delete all',
        child: const Icon(FontAwesomeIcons.trashAlt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
