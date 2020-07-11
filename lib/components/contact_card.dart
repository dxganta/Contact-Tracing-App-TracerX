import 'package:flutter/material.dart';

import 'bottom_sheet_text.dart';

class ContactCard extends StatelessWidget {
  ContactCard(
      {this.imagePath,
      this.email,
      this.infection,
      this.contactUsername,
      this.contactTime,
      this.contactLocation});

  final String imagePath;
  final String email;
  final String infection;
  final String contactUsername;
  final DateTime contactTime;
  final String contactLocation;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(imagePath),
        ),
        trailing: Icon(Icons.more_horiz),
        title: Text(
          email,
          style: TextStyle(
            color: Colors.deepPurple[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(infection),
        onTap: () => showModalBottomSheet(
            context: context,
            builder: (builder) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    BottomSheetText(
                        question: 'Username', result: contactUsername),
                    SizedBox(height: 5.0),
                    BottomSheetText(
                        question: 'Contact Time',
                        result: contactTime.toString()),
                    SizedBox(height: 5.0),
                    BottomSheetText(
                        question: 'Contact Location', result: contactLocation),
                    SizedBox(height: 5.0),
                    BottomSheetText(question: 'Times Contacted', result: '3'),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
