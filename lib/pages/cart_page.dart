import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_app/Model/usefulData.dart';
import 'package:login_screen_app/pages/cart_prod_tile.dart';

class CartPage extends StatefulWidget {
  CartPage();
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // final scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refIndKey =
      new GlobalKey<RefreshIndicatorState>();
  // String st = 'hello';
  DocumentReference _doc;
  bool enable = true;

  @override
  void initState() {
    super.initState();

    // cartData.forEach((key, val) {
    //   val.forEach((f) {

    //       cartProdData.add(cartDocs[].data);

    //   });
    // });
    //  documentReference.get().then((ds){
    //    Map<String,dynamic> map=ds.data;

    //    if(map['cart'].isNotEmpty){
    //      print(map['cart']);
    //      List<String> ls=map['cart'].keys;
    //      print(ls);
    //      ls.forEach((f){
    //         print('doc id is'+f.toString());

    //      });
    //    }
    //  });
    //print('len is ' + cartDocs.length.toString());
    if (cartDocs.length == 0) {
      // print('cart data is' + userData['cart'].toString());
      // print(userData['cart'].runtimeType);

      Map<dynamic, dynamic> l1 = userData['cart'];
      //print(l1.toString());
      Iterable<dynamic> k = l1.keys;
      List<dynamic> keys = k.toList();
      if (keys.length == 0) {
        setState(() {
          enable = false;
        });
      }
      for (var i = 0; i < keys.length; i++) {
        //print(l1[keys[i].toString()]);
        String u = keys[i].substring(0, 28);
        String d = keys[i].substring(29, 49);
       // print(u + "-" + d);

        _doc = Firestore.instance.document('/users/' + u + '/products/' + d);
        
        _doc.get().then((v) {
          cartDocs.add(v);
          docsPath.add(_doc);
          qty.add(l1[keys[i]]);
          cartProdData.add(v.data);
          if (i == (keys.length - 1)) {
            setState(() {
              enable = false;
            });
          }
        });
      }
    } else {
      setState(() {
        enable = false;
      });
      print('no docs present');
    }
    // Future.forEach(l1.entries, (mapEntry){

    // });

    // cartDocs.forEach((f) {
    //   cartProdData.add(f.data);
    // });
    // print("cartDocs:" + cartDocs.toString());
    // print("cartProdData:" + cartProdData.toString());
    // print('quantities are:' + qty.toString());
    // _collectionReference =
    //     Firestore.instance.collection('/users/' + userId + '/products');
//     if (querySnapshot == null)
//       querySnapshot = _collectionReference.getDocuments();
//     print(querySnapshot);
// Firestore _firestore=Firestore.instance;
//     Future _cal=Future.forEach(cartData.keys, _firestore.document('/users/'  '/products/' ).get());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  key: scaffoldkey,
      appBar: AppBar(
        title: Text('Shopping cart'),
      ),
      body: RefreshIndicator(
          key: _refIndKey,
          onRefresh: refreshPage,
          child: enable == true
              ? Center(
                  child: cartDocs.length == 0
                      ? Text('Empty')
                      : CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: cartDocs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return
                        //          Card(
                        //   child: ListTile(
                        //     title: Text(cartProdData[index]['title']),
                        //      subtitle: Text('₹' + cartProdData[index]['price']),
                        //     // onTap: () {
                        //     //   getShop(listOfIds[index]);
                        //     // },
                        //   ),
                        // );
                        //Text('hii');
                        CartProdTile(index);
                  })
          // FutureBuilder(
          //   future: querySnapshot,
          //   builder: (BuildContext buildContext, AsyncSnapshot snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       return showData(snapshot.data);
          //     } else if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     } else
          //       return somethingWentWrong();
          //   },
          // ),
          ),
    );
    // onRefresh: () {
    //   setState(() {
    //     st='hello world';
    //   });
    //return Future.delayed(Duration(milliseconds: 2000));
  }

  Widget somethingWentWrong() {
    return Text('error');
  }

  Future<void> refreshPage() {
    // querySnapshot = _collectionReference.getDocuments();
    // return querySnapshot.then((v) {
    //   setState(() {
    //     firstInstance = false;
    //     listMap = List();
    //     mapOfImages = {};
    //     indexes = List();
    //   });
    // }).catchError((e) {
    //   print(e);
    // });
    setState(() {
      enable = true;
    });
    Map<dynamic, dynamic> l1 = userData['cart'];
    //print(l1.toString());
    Iterable<dynamic> k = l1.keys;
    List<dynamic> keys = k.toList();
    if (keys.length == 0) {
      setState(() {
        enable = false;
      });
    }
    cartDocs = List();
    cartProdData = List();
    cartImages = {};
    cartItemIndexes = List();
    qty = List();
    docsPath=List();
    //print('len is ' + cartDocs.length.toString());
    //
    //  print('cart data is' + userData['cart'].toString());
    //  print(userData['cart'].runtimeType);
    return documentReference.get().then((DocumentSnapshot ds) {
      //print('entering into profilepage ' + ds.data.toString());
      ds.data.forEach((key, value) {
        userData[key] = value;
      });
      //print('out from profile page');
      Map<dynamic, dynamic> l1 = userData['cart'];
     // print(l1.toString());
      Iterable<dynamic> k = l1.keys;
      List<dynamic> keys = k.toList();
      for (var i = 0; i < keys.length; i++) {
        //print(l1[keys[i].toString()]);
        String u = keys[i].substring(0, 28);
        String d = keys[i].substring(29, 49);
       // print(u + "-" + d);
        _doc = Firestore.instance.document('/users/' + u + '/products/' + d);
        _doc.get().then((v) {
          cartDocs.add(v);
          docsPath.add(_doc);
          qty.add(l1[keys[i]]);
          cartProdData.add(v.data);
          if (i >= keys.length - 1) {
            setState(() {
              enable = false;
            });
          }
        });
      }
    });
    // } else {
    //   setState(() {
    //     enable = false;
    //   });
    //   print('no docs present');
    // }
  }
}
