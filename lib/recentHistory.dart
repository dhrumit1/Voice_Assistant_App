import 'package:flutter/material.dart';
import 'package:gpt/recentData.dart';

class History extends StatefulWidget {
  List<RecentData> recentData;
  int index = 0;
  History(this.recentData);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice Assistant App"),
        titleSpacing: 30.00,
      ),
      body: ListView.builder(itemCount: widget.recentData.length,itemBuilder: (context, index) {
        return Card(child: ListTile(
          leading: Text((index+1).toString()),
          title: Text(widget.recentData[index].question),
          subtitle: Text(widget.recentData[index].answere),
        ),);
      },),
    );
  }
}