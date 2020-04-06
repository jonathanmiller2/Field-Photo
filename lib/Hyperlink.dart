import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class Hyperlink extends StatefulWidget {
  final String url;
  final String label;
  
  const Hyperlink({this.url, this.label});
  
  _HyperlinkState createState() {
    return _HyperlinkState();
  }
}

class _HyperlinkState extends State<Hyperlink> {
  
  bool pressed = false;
  
  _launchURL() async {
    if (await canLaunch(widget.url)) {
      await launch(widget.url);
    } else {
      throw 'Could not launch $widget.url';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Center(
        child: Text(
          widget.label,
          style: TextStyle(
              color: pressed ? Colors.white : Colors.blue[900],
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      onTap: () {
        setState(() {
          pressed = false;
          _launchURL();
        });
      },
      onTapDown: (a) {
        setState(() {
          pressed = true;
        });
      },
    );
  }
}
