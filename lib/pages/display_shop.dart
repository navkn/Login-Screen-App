import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_app/Model/usefulData.dart';
import 'package:login_screen_app/pages/chat_page.dart';
//import 'package:login_screen_app/pages/add_product.dart';
import 'package:login_screen_app/pages/prod_tile.dart';
//import 'package:login_screen_app/pages/product_grid_tile.dart';

class DisplayShop extends StatefulWidget {
  // final String userId;
  final String uid;
  DisplayShop(this.uid);
  @override
  _DisplayShop createState() => _DisplayShop();
}

class _DisplayShop extends State<DisplayShop> {
  CollectionReference _collectionReference;

  int height;
  final scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
   // print("shopId:" + widget.uid);
    _collectionReference =
        Firestore.instance.collection('/users/' + widget.uid + '/products');
    if (widget.uid != prevShopId) {
      firstInstanceq = false;
      listMapq = List();
      mapOfImagesq = {};
      indexesq = List();
    }
    // if (querySnapshotq == null)
    querySnapshotq = _collectionReference.getDocuments();
    // print("firstInstance:" + firstInstanceq.toString());
    // print("firstInstance:" + listMapq.toString());
    // print("firstInstance:" + mapOfImagesq.toString());
    // print("firstInstance:" + indexesq.toString());

    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  @override
  void dispose() {
    super.dispose();
    prevShopId = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[showChatIcon()],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: refreshPage,
        child: FutureBuilder(
          future: querySnapshotq,
          builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return showData(snapshot.data);
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
              return somethingWentWrong();
          },
        ),
      ),
    );
  }

  Widget somethingWentWrong() {
    return Text('error');
  }

  Widget showData(QuerySnapshot data) {
    //  Uint8List imagefile;
    if (firstInstanceq == false) {
      firstInstanceq = true;
      listOfDocumentsq = data.documents;
     // print("docs:" + listOfDocuments.toString());
      for (var doc in listOfDocumentsq) {
        // Map<String, dynamic> map = doc.data;
        //for (var key in map.keys) {
        listMapq.add(doc.data);
        //  }
      }
    }
   // print("listMap:" + listMap.toString());

    //  print(ls.toString());
    return GridView.builder(
      itemCount: listMapq.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            (MediaQuery.of(context).orientation == Orientation.portrait)
                ? 2
                : 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ProdTile(index);
      },
    );
  }

  Future<void> refreshPage() {
    querySnapshotq = _collectionReference.getDocuments();
    return querySnapshotq.then((v) {
      setState(() {
        firstInstanceq = false;
        listMapq = List();
        mapOfImagesq = {};
        indexesq = List();
      });
    }).catchError((e) {
      print(e);
    });
  }

  Widget showChatIcon() {
    return Container(
      child:  InkResponse(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
               // print(140);
                return ChatPage(widget.uid);
              }));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.chat),
            ),
          ),
    );
  }
}
