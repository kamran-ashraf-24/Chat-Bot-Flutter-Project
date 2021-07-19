import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:chat_bot/api_key.dart';
import 'package:chat_bot/model.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var textController = TextEditingController();
  String text = '';
  List<Map> list = [];
  void fetchData(String query) async {
    // get bid and key from https://brainshop.ai/
    String botUrl =
        'http://api.brainshop.ai/get?bid=$BOT_ID&key=$API_KEY&uid=[uid]&msg=$query';
    var url = Uri.parse(botUrl);
    var response = await http.get(url);

    var jsonDecode = json.decode(response.body);
    Model message = new Model();

    message = Model.fromMap(jsonDecode);
    setState(() {
      list.insert(0, {'data': 0, "message": '${message.message.toString()}'});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 8.0,
        ),
        Expanded(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            physics: BouncingScrollPhysics(),
            reverse: true,
            itemCount: list.length,
            itemBuilder: (context, index) => list[index]['data'] == 0
                ? BotItem(
                    text:list[index]['message'],
                  )
                : UserItem(
                    text: list[index]['message'],
                  ),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          children: [
            SizedBox(
              width: 18.0,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(
                    width: 1.0,
                    color: Theme.of(context).accentColor.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: textController,
                  cursorColor: Theme.of(context).accentColor,
                  decoration: InputDecoration(
                    hintText: 'Type here...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Container(
              padding: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                ),
                onPressed: () {
                  if (textController.text.isEmpty) {
                  } else {
                    setState(() {
                      list.insert(
                          0, {'data': 1, 'message': textController.text});
                      fetchData(textController.text);
                    });
                    textController.clear();
                  }
                },
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
      ],
    );
  }
}

class BotItem extends StatelessWidget {
  const BotItem({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Wrap(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 12.0,
                right: 60.0,
                left: 40,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border.all(
                  width: 1.0,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 12,
          left: 0,
          child: Image.asset(
            'assets/robot.png',
            width: 32,
          ),
        ),
      ],
    );
  }
}

class UserItem extends StatelessWidget {
  const UserItem({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              margin: EdgeInsets.only(
                top: 12.0,
                left: 60.0,
                right: 36,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 12,
          right: 0,
          child: Image.asset(
            'assets/man.png',
            width: 30,
          ),
        ),
      ],
    );
  }
}
