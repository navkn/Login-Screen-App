import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_app/Model/usefulData.dart';
import 'package:login_screen_app/pages/chat_page.dart';

class ListOfChats extends StatefulWidget {
  //String peerId;

  ListOfChats();
  @override
  _ListOfChatsState createState() => _ListOfChatsState();
}

class _ListOfChatsState extends State<ListOfChats> {
  bool isLoading = true;
  Stream str;
  @override
  void initState() {
    super.initState();
    collectAllChats();
  }

  void collectAllChats() async {
    print(userId.toString());
    await Firestore.instance
        .collection('chats')
        .where('from', isEqualTo: userId)
        //       .where('to', isEqualTo: userId)
        .getDocuments()
        .then((v) {
      print('list of docs is:' + v.documents.toString());
      print(v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'from Buyers'),
              Tab(text: 'To Sellers'),
            ],
          ),
        ),
        body: TabBarView(children: [
          Container(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('chats')
                    // .where('from', isEqualTo: userId)
                    .where('to', isEqualTo: userId)
                    // .orderBy('timeStamp')
                    .snapshots(),
                builder: (context, asyncSnap) {
                  if (asyncSnap.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (asyncSnap.connectionState == ConnectionState.active) {
                    QuerySnapshot qs = asyncSnap.data;
                    List<DocumentSnapshot> ls = qs.documents;

                    // DocumentSnapshot data = asyncSnap.data;
                    // Map<String, dynamic> cameData = data.data;
                    // print(cameData.toString());
                    if (ls.length != 0)
                      return ListView.builder(
                          itemCount: ls.length,
                          itemBuilder: (context, ind) {
                            Map<String, dynamic> cameData = ls[ind].data;
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  // print(140);
                                  return ChatPage(cameData['from'].toString());
                                }));
                              },
                              child: Card(
                                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    padding:
                                        EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    child: Text(cameData['from'].toString())),
                              ),
                            );
                          });
                    return Center(child: Text('no chats yet'));
                  }
                  if (asyncSnap.connectionState == ConnectionState.done) {
                    return Text('connection done');
                  }
                  return Text('nothing returned');
                }),
          ),
          Container(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('chats')
                    .where('from', isEqualTo: userId)
                    // .where('to', isEqualTo: userId)
                    // .orderBy('timeStamp')
                    .snapshots(),
                builder: (context, asyncSnap) {
                  if (asyncSnap.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (asyncSnap.connectionState == ConnectionState.active) {
                    QuerySnapshot qs = asyncSnap.data;
                    List<DocumentSnapshot> ls = qs.documents;

                    // DocumentSnapshot data = asyncSnap.data;
                    // Map<String, dynamic> cameData = data.data;
                    // print(cameData.toString());
                    if (ls.length != 0)
                      return ListView.builder(
                          itemCount: ls.length,
                          itemBuilder: (context, ind) {
                            Map<String, dynamic> cameData = ls[ind].data;
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  // print(140);
                                  return ChatPage(cameData['to'].toString());
                                }));
                              },
                              child: Card(
                                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: Text(cameData['to'].toString()),
                                ),
                              ),
                            );
                          });
                    return Center(child: Text('no chats yet'));
                  }
                  if (asyncSnap.connectionState == ConnectionState.done) {
                    return Text('connection success');
                  }
                  return Text('nothing returned');
                }),
          ),
        ]),
      ),
    );
  }
}
