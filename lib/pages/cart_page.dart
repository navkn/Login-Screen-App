import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_app/Model/usefulData.dart';
import 'package:login_screen_app/pages/cart_prod_tile.dart';
import 'package:login_screen_app/pages/product_grid_tile.dart';

class CartPage extends StatefulWidget {
  CartPage();
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
 // final scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String st = 'hello';
  CollectionReference _collectionReference;

  @override
  void initState() {
    super.initState();

    // cartData.forEach((key, val) {
    //   val.forEach((f) {

    //       cartProdData.add(cartDocs[].data);

    //   });
    // });
    cartDocs.forEach((f) {
      cartProdData.add(f.data);
    });
    print("cartDocs:" + cartDocs.toString());
    print("cartProdData:" + cartProdData.toString());
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
      body: 
      // RefreshIndicator(
      //     key: _refreshIndicatorKey,
      //     onRefresh: refreshPage,
      //     child:
           ListView.builder(
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
          // ),
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
    querySnapshot = _collectionReference.getDocuments();
    return querySnapshot.then((v) {
      setState(() {
        firstInstance = false;
        listMap = List();
        mapOfImages = {};
        indexes = List();
      });
    }).catchError((e) {
      print(e);
    });
  }

  Widget showData(QuerySnapshot data) {
    //  Uint8List imagefile;
    if (firstInstance == false) {
      firstInstance = true;
      listOfDocuments = data.documents;
      print(listOfDocuments);
      for (var doc in listOfDocuments) {
        listMap.add(doc.data);
        // for (var key in map.keys) {
        //   listMap.add(map[key]);
        // }
      }
    }
    print(listMap);

    //  print(ls.toString());
    return GridView.builder(
      itemCount: listMap.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            (MediaQuery.of(context).orientation == Orientation.portrait)
                ? 2
                : 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ProductGridTile(index);
      },
    );
  }
}
