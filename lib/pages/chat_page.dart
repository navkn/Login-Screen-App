import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_app/Model/usefulData.dart';

class ChatPage extends StatefulWidget {
  final String peerId;

  ChatPage(this.peerId);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  GlobalKey<FormState> formKey1 = new GlobalKey<FormState>();
  TextEditingController textMsgController = TextEditingController();
  ScrollController listScrollController = ScrollController();
  bool isLoading = true;
  Stream<DocumentSnapshot> strsnap;
  String chatId;
  Map<String, dynamic> msgData;
  String textMsg;
  Map<String, dynamic> gotData = Map();

  @override
  void initState() {
    super.initState();
    String uid = userId;

    if (widget.peerId.hashCode < uid.hashCode) {
      chatId = widget.peerId + '-' + uid;
    } else
      chatId = uid + '-' + widget.peerId;

    callCreateChatSession();
  }

  void callCreateChatSession() async {
    await createChatSession();
    strsnap.listen((event) {
      gotData = event.data;
      print('listening');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(children: [
              Expanded(
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('chats')
                        .document(chatId)
                        .snapshots(),
                    builder: (context, asyncSnap) {
                      if (asyncSnap.connectionState == ConnectionState.active) {
                        print('active conn');
                        if (asyncSnap.hasData) {
                          DocumentSnapshot data = asyncSnap.data;
                          Map<String, dynamic> cameData = data.data;
                          //print('keys re:'+cameData.keys.toString());
                          List<dynamic> lsd = cameData['messages'];
                          // lsd = lsd.reversed.toList();
                          return ListView.builder(
                            padding: EdgeInsets.all(10.0),
                            itemBuilder: (context, index) {
                              if (lsd[index]['owner'] == userId) {
                                return Container(
                                  padding: EdgeInsets.fromLTRB(
                                      15.0, 10.0, 15.0, 10.0),
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  margin: EdgeInsets.only(
                                      bottom: 5.0, right: 5.0, left: 50.0),
                                  child: Card(
                                    elevation: 5.0,
                                    child: ListTile(
                                      title: Text(
                                          lsd[index]['content'].toString()),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  padding:
                                      EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 5.0),
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  margin:
                                      EdgeInsets.only(right: 50.0, left: 5.0),
                                  child: Card(
                                    elevation: 5.0,
                                    child: ListTile(
                                      title: Text(
                                          lsd[index]['content'].toString()),
                                    ),
                                  ),
                                );
                              }
                            },
                            itemCount: lsd.length,
                            //reverse: true,
                            controller: listScrollController,
                          );
                          // return Text(lsd[0]['content'].toString());
                        }

                        return Text('active conn');
                      } else if (asyncSnap.connectionState ==
                          ConnectionState.done) {
                        print('content done');
                        return Text('content done');
                      } else if (asyncSnap.connectionState ==
                          ConnectionState.waiting) {
                        print('waiting for conn');

                        return Text('waiting for conn');
                      }
                      return Container();
                    }),
              ),
              Container(
                height: 50.0,
                margin:
                    EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
                decoration: new BoxDecoration(
                    border: new Border(
                        top: new BorderSide(
                            color: Colors.greenAccent, width: 0.5)),
                    color: Colors.white),
                child: Form(
                  key: formKey1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration.collapsed(
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(color: Colors.greenAccent),
                          ),
                          validator: (val) =>
                              val == null ? 'cannot be empty' : null,
                          onSaved: (val) => textMsg = val,
                          controller: textMsgController,
                          //initialValue: userData['address'],
                        ),
                      ),
                      Container(
                        child: RaisedButton(
                            child: Text('send'),
                            onPressed: () async {
                              final f1 = formKey1.currentState;
                              int counter = 0;
                              if (f1.validate()) {
                                f1.save();
                                msgData = {
                                  'content': textMsg,
                                  'owner': userId,
                                  'sentAt': DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString()
                                };

                                List<dynamic> listOfMsgs = List();
                                print('list:' + listOfMsgs.toString());
                                print('');
                                List<dynamic> ls = gotData['messages'];
                                counter = gotData['count']+1;
                               
                                print('got data lenght is:' +
                                    ls.length.toString());
                                print('');
                                for (var i = 0; i < ls.length; i++) {
                                  listOfMsgs.add(ls[i]);
                                  print('adding :' + ls[i].toString());
                                  print('');
                                }

                                listOfMsgs.add(msgData);

                                print('appended list is :' +
                                    listOfMsgs.toString());
                                print('');
                                Map<String, dynamic> updData = {
                                  'count': counter,
                                  'from': userId,
                                  'to': widget.peerId,
                                  'timeStamp': msgData['sentAt'],
                                  'messages': listOfMsgs
                                };
                                await Firestore.instance
                                    .collection('chats')
                                    .document(chatId)
                                    .updateData(updData);
                                textMsgController.clear();
                                listScrollController.jumpTo(listScrollController
                                    .position.maxScrollExtent);
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
    );
  }

  Future<void> createChatSession() async {
    print('chatId is ' + chatId);
    // DocumentReference docref =
    //     Firestore.instance.collection('messages').document(chatId);
    return await Firestore.instance
        .collection('chats')
        .document(chatId)
        .get()
        .then((ds) async {
      if (ds.data != null) {
        print('doc id :' + ds.documentID);
        strsnap = Firestore.instance
            .collection('chats')
            .document(chatId)
            .snapshots()
            .asBroadcastStream();
        print('setting state');
        setState(() {
          isLoading = false;
        });
      } else {
        Map<String, dynamic> initData = {
          'count': 0,
          'from': userId,
          'to': widget.peerId,
          'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'messages': List<dynamic>()
        };
        await Firestore.instance
            .collection('chats')
            .document(chatId)
            .setData(initData)
            .then((v) {
          print('doc init success');
          print('seeting state');
          strsnap = Firestore.instance
              .collection('chats')
              .document(chatId)
              .snapshots()
              .asBroadcastStream();
          setState(() {
            isLoading = false;
          });
        }).catchError((err) {
          print('Error is :' + err);
        });
      }

      //return Future.delayed(Duration.zero);
    });
    // return await Firestore.instance
    //     .collection('messages')
    //     .document(chatId)
    //     .get()
    //     .then((value) {
    //   print('seeting state');
    //   setState(() {
    //     isLoading = false;
    //   });
    //   Map<String, dynamic> initData = {'count': 0, 'messages': List()};
    //   if (value == null) {
    //     Firestore.instance
    //         .collection('messages')
    //         .document(chatId)
    //         .setData(initData)
    //         .then((v) {
    //       print('set success');
    //     }).catchError((err) {
    //       print(err);
    //     });
    //   } else {
    //     print(value.data);
    //     strsnap = Firestore.instance
    //         .collection('messages')
    //         .document(chatId)
    //         .snapshots();
    //   }
    // }).catchError((er) {
    //   print(er.toString());
    //   print('error found');
    // });

    // Firestore.instance.document()..then((v){
    //   print('data is :'+v.data.toString());
    // }).catchError((e){
    //   print(e.toString());
    // });
  }

  // Widget buildItem(int index, String content,bool isFirstPerson) {
  //   if (isFirstPerson == true) {
  //     // Right (my message)
  //     return Row(
  //       children: <Widget>[
  //         Container(
  //                 child: Text(
  //                   content,
  //                  // style: TextStyle(color: primaryColor),
  //                 ),
  //                 padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
  //                 width: 200.0,
  //                 decoration: BoxDecoration( borderRadius: BorderRadius.circular(8.0)),
  //                 margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
  //               )
  //             ,Container(
  //                     child: FlatButton(
  //                       child: Material(
  //                         child: CachedNetworkImage(
  //                           placeholder: (context, url) => Container(
  //                             child: CircularProgressIndicator(
  //                               valueColor: AlwaysStoppedAnimation<Color>(themeColor),
  //                             ),
  //                             width: 200.0,
  //                             height: 200.0,
  //                             padding: EdgeInsets.all(70.0),
  //                             decoration: BoxDecoration(
  //                               color: greyColor2,
  //                               borderRadius: BorderRadius.all(
  //                                 Radius.circular(8.0),
  //                               ),
  //                             ),
  //                           ),
  //                           errorWidget: (context, url, error) => Material(
  //                             child: Image.asset(
  //                               'images/img_not_available.jpeg',
  //                               width: 200.0,
  //                               height: 200.0,
  //                               fit: BoxFit.cover,
  //                             ),
  //                             borderRadius: BorderRadius.all(
  //                               Radius.circular(8.0),
  //                             ),
  //                             clipBehavior: Clip.hardEdge,
  //                           ),
  //                           imageUrl: document['content'],
  //                           width: 200.0,
  //                           height: 200.0,
  //                           fit: BoxFit.cover,
  //                         ),
  //                         borderRadius: BorderRadius.all(Radius.circular(8.0)),
  //                         clipBehavior: Clip.hardEdge,
  //                       ),
  //                       onPressed: () {
  //                         Navigator.push(
  //                             context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
  //                       },
  //                       padding: EdgeInsets.all(0),
  //                     ),
  //                     margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
  //                   )
  //                 // Sticker
  //                 : Container(
  //                     child: new Image.asset(
  //                       'images/${document['content']}.gif',
  //                       width: 100.0,
  //                       height: 100.0,
  //                       fit: BoxFit.cover,
  //                     ),
  //                     margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
  //                   ),
  //       ],
  //       mainAxisAlignment: MainAxisAlignment.end,
  //     );
  //   } else {
  //     // Left (peer message)
  //     return Container(
  //       child: Column(
  //         children: <Widget>[
  //           Row(
  //             children: <Widget>[
  //               isLastMessageLeft(index)
  //                   ? Material(
  //                       child: CachedNetworkImage(
  //                         placeholder: (context, url) => Container(
  //                           child: CircularProgressIndicator(
  //                             strokeWidth: 1.0,
  //                             valueColor: AlwaysStoppedAnimation<Color>(themeColor),
  //                           ),
  //                           width: 35.0,
  //                           height: 35.0,
  //                           padding: EdgeInsets.all(10.0),
  //                         ),
  //                         imageUrl: peerAvatar,
  //                         width: 35.0,
  //                         height: 35.0,
  //                         fit: BoxFit.cover,
  //                       ),
  //                       borderRadius: BorderRadius.all(
  //                         Radius.circular(18.0),
  //                       ),
  //                       clipBehavior: Clip.hardEdge,
  //                     )
  //                   : Container(width: 35.0),
  //               document['type'] == 0
  //                   ? Container(
  //                       child: Text(
  //                         document['content'],
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                       padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
  //                       width: 200.0,
  //                       decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(8.0)),
  //                       margin: EdgeInsets.only(left: 10.0),
  //                     )
  //                   : document['type'] == 1
  //                       ? Container(
  //                           child: FlatButton(
  //                             child: Material(
  //                               child: CachedNetworkImage(
  //                                 placeholder: (context, url) => Container(
  //                                   child: CircularProgressIndicator(
  //                                     valueColor: AlwaysStoppedAnimation<Color>(themeColor),
  //                                   ),
  //                                   width: 200.0,
  //                                   height: 200.0,
  //                                   padding: EdgeInsets.all(70.0),
  //                                   decoration: BoxDecoration(
  //                                     color: greyColor2,
  //                                     borderRadius: BorderRadius.all(
  //                                       Radius.circular(8.0),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 errorWidget: (context, url, error) => Material(
  //                                   child: Image.asset(
  //                                     'images/img_not_available.jpeg',
  //                                     width: 200.0,
  //                                     height: 200.0,
  //                                     fit: BoxFit.cover,
  //                                   ),
  //                                   borderRadius: BorderRadius.all(
  //                                     Radius.circular(8.0),
  //                                   ),
  //                                   clipBehavior: Clip.hardEdge,
  //                                 ),
  //                                 imageUrl: document['content'],
  //                                 width: 200.0,
  //                                 height: 200.0,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                               borderRadius: BorderRadius.all(Radius.circular(8.0)),
  //                               clipBehavior: Clip.hardEdge,
  //                             ),
  //                             onPressed: () {
  //                               Navigator.push(context,
  //                                   MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
  //                             },
  //                             padding: EdgeInsets.all(0),
  //                           ),
  //                           margin: EdgeInsets.only(left: 10.0),
  //                         )
  //                       : Container(
  //                           child: new Image.asset(
  //                             'images/${document['content']}.gif',
  //                             width: 100.0,
  //                             height: 100.0,
  //                             fit: BoxFit.cover,
  //                           ),
  //                           margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
  //                         ),
  //             ],
  //           ),

  //           // Time
  //           isLastMessageLeft(index)
  //               ? Container(
  //                   child: Text(
  //                     DateFormat('dd MMM kk:mm')
  //                         .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp']))),
  //                     style: TextStyle(color: greyColor, fontSize: 12.0, fontStyle: FontStyle.italic),
  //                   ),
  //                   margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
  //                 )
  //               : Container()
  //         ],
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //       ),
  //       margin: EdgeInsets.only(bottom: 10.0),
  //     );
  //   }
  // }

}
