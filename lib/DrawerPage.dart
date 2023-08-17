import 'package:flutter/material.dart';
import 'package:gpt/recentData.dart';
import 'package:gpt/recentHistory.dart';

class DrawerPage extends StatefulWidget {
  List<RecentData> recentData;
  DrawerPage(this.recentData);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('History'),
              onTap: () {
                // Add your navigation logic here
                // Close the drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) => History(widget.recentData),));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Add your navigation logic here
                Navigator.pop(context); // Close the drawer
              },
            ),
          ]
      )
    );
  }
}