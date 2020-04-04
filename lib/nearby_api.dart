import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

import 'constants.dart';

class NearbyMe extends StatefulWidget {
  static const String id = 'nearby_me';

  @override
  _NearbyMeState createState() => _NearbyMeState();
}

class _NearbyMeState extends State<NearbyMe> {
  final Strategy strategy = Strategy.P2P_STAR;
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  FirebaseUser userName;

  String getUsernameOfEmail({String email}) {
    String res = '';

    _firestore.collection('users').document(email).get().then((doc) {
      if (doc.exists) {
        res = doc.data['username'];
      } else {
        // doc.data() will be undefined in this case
        print("No such document!");
      }
    });
    return res;
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        userName = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
              color: Colors.deepOrange,
              onPressed: () {
                Nearby().askLocationAndExternalStoragePermission();
              },
              child: Text(
                'Grant Permissions',
                style: kButtonTextStyle,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Colors.deepOrange,
                  onPressed: () async {
                    try {
                      bool a = await Nearby().startAdvertising(
                        userName.email,
                        strategy,
                        onConnectionInitiated: null,
                        onConnectionResult: (id, status) {
                          print(status);
                        },
                        onDisconnected: (id) {
                          print('Disconnected $id');
                        },
                      );

                      print('ADVERTISING ${a.toString()}');
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(
                    'Start Advertising',
                    style: kButtonTextStyle,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                RaisedButton(
                  color: Colors.deepOrange,
                  onPressed: () async {
                    try {
                      bool a = await Nearby()
                          .startDiscovery(userName.email, strategy,
                              onEndpointFound: (id, name, serviceId) {
                        print(
                            'I saw id:$id with name:$name'); // the name here is an email

                        var docRef = _firestore
                            .collection('users')
                            .document(userName.email);

                        //  When I discover someone I will see their email
                        docRef.collection('met_with').document(name).setData({
                          'username': getUsernameOfEmail(email: name),
                        });
                      }, onEndpointLost: (id) {
                        print(id);
                      });
                      print('DISCOVERING: ${a.toString()}');
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text(
                    'Start Discovery',
                    style: kButtonTextStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
