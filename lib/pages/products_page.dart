import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_screen_app/Model/usefulData.dart';
import 'package:login_screen_app/pages/add_product.dart';
import 'package:login_screen_app/pages/product_grid_tile.dart';

class ProductsPage extends StatefulWidget {
  // final String userId;

  ProductsPage();
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  CollectionReference _collectionReference;

  int height;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    _collectionReference =
        Firestore.instance.collection('/users/' + userId + '/products');
    if (querySnapshot == null)
      querySnapshot = _collectionReference.getDocuments();
    //print(querySnapshot);
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: refreshPage,
        child: FutureBuilder(
          future: querySnapshot,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddProduct();
          })).then((v) {
            if (v == true) refreshPage();
          })
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.greenAccent,
      ),
    );
  }

  Widget somethingWentWrong() {
    return Text('error');
  }

  Widget showData(QuerySnapshot data) {
    //  Uint8List imagefile;
    if (firstInstance == false) {
      firstInstance = true;
      listOfDocuments = data.documents;
      //print(listOfDocuments);
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
        return ProductGridTile(index, showDiagolueBox);
      },
    );
  }

  Future<void> showDiagolueBox(int index) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: 200.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Do you want to delete this item?',
                style: TextStyle(color: Colors.green),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.all(15.0),
            //   child: Text(
            //     'Awesome',
            //     style: TextStyle(color: Colors.red),
            //   ),
            // ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red, fontSize: 18.0),
                    )),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      print(listMap[index]);
                      Firestore.instance
                          .document('/users/' +
                              userId +
                              '/products/' +
                              listMap[index]['id'].toString())
                          .delete().then((_){
                            print('deleted successfully');
                            refreshPage();
                            showBar('deleted successfully');
                          });
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red, fontSize: 18.0),
                    )),
              ],
            )
          ],
        ),
      ),
    );
    return showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

 Future<void> showBar(String str) {
    SnackBar snackbar = new SnackBar(
      content: new Text(str),
      duration: Duration(seconds: 2),
    );
    return _scaffoldkey.currentState.showSnackBar(snackbar).closed;
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
}
