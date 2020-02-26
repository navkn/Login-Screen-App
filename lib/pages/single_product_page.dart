import 'package:flutter/material.dart';
import 'package:login_screen_app/Model/usefulData.dart';
import 'package:login_screen_app/pages/cart_page.dart';

class SingleProductPage extends StatefulWidget {
  final int index;
  SingleProductPage(this.index);
  @override
  _SingleProductPageState createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  bool favourite = false;
  String title;
  String desc;
  int items;
  bool addedToCart = false;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  // void initState() {
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // toolbarOpacity: 0.8,
        centerTitle: true,
        title: Text('Product Page'),
        actions: <Widget>[
          InkResponse(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                print(140);
                return CartPage();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart),
            ),
          )
          //  Image.asset(
          //     favourite
          //         ? "assets/heart_icon.png"
          //         : "assets/heart_icon_disabled.png",
          //     width: 30,
          //     height: 30,
          //   )
        ],
      ),
      body:
          // SafeArea(
          //   child:
          SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 10),
          //alignment: AlignmentGeometry.,
          child: Column(
            children: <Widget>[
              // SizedBox(
              //   height: kToolbarHeight ,
              // ),
              Text(
                listMapq[widget.index]['title'],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              hero(),
              spaceVertical(10),
              //Center Items
              // Expanded(
              sections(),
              // ),
            ],
          ),
        ),
        //  ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RaisedButton(
          color: Colors.orangeAccent,
          child: Text('Add to Cart'),
          onPressed: () {
            // print('cartdata'+cartData.toString());
            // print('cartdocs:'+cartDocs[0].toString());
           // cartDocs.add(listOfDocumentsq[widget.index]);
            Map<dynamic, dynamic> other = {};
            Map<String, dynamic> cart = {};
            documentReference.get().then((v) {
              Map<String, dynamic> d = v.data;

              cart = {
                'cart': {
                  listOfDocumentsq[widget.index].data['shopId'].toString() +
                      '-' +
                      listOfDocumentsq[widget.index].documentID: 1
                }
              };
              print('cart is' + cart.toString());
              if (d.containsKey('cart')) {
                print('contains key cart');
                if (d['cart'] != null) {
                  // other.addAll({listOfDocumentsq[widget.index].documentID: 1});
                  other = d['cart'];
                  print('cart is not null');
                  print(other);
                  other.addAll(cart['cart']);
                  // Map<String, dynamic> oth1 = other['cart'];
                  Map<String, dynamic> oth2 = {'cart': other};
                  print(oth2);
                  documentReference.updateData(oth2).then((v) {
                    print('success added 1');
                  });
                } else {
                  documentReference.updateData(cart['cart']).then((v) {
                    print('success added 2');
                  });
                }
              } else
                documentReference.updateData(cart).then((v) {
                  print('success added 3');
                });

              //  Map<dynamic,dynamic> o = {
              //   'cart': {listOfDocumentsq[widget.index].documentID: 1}
              // };
            });

            // Firestore.instance
            //     .collection('users')
            //     .document('$userId')
            //     .collection('cart')
            //     .document()
            //     .setData(data)
            //     .then((_) {
            //   print('added data');
            // });
            // print('id is' + doc.documentID);
            //  print('col is'+col.toString());
            // showDialog()
            // if (cartData[cartUId] != null)
            //   {cartData[cartUId].add(listOfDocumentsq[widget.index].documentID);
            //   }
            // else
            //   cartData[cartUId] = [listOfDocumentsq[widget.index].documentID];
            // print('cartdata'+cartData.toString());
            print('cartdocs:' + cartDocs.toString());
            //listOfDocumentsq[widget.index].documentID;

            showBar('Added successfully');
            print('added to cart');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 2,
          child: Container(
            // height: ,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(
                favourite
                    ? "assets/heart_icon.png"
                    : "assets/heart_icon_disabled.png",
                width: 20,
                height: 20,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          onPressed: () {
            setState(() {
              favourite = !favourite;
            });
          }),
    );
  }

  void showBar(String str) {
    SnackBar snackbar = new SnackBar(
      content: new Text(str),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget hero() {
    return Container(
      height: (MediaQuery.of(context).size.height -
              kToolbarHeight -
              kBottomNavigationBarHeight) *
          0.5,
      width: (MediaQuery.of(context).size.width),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Image.memory(
          mapOfImagesq[widget.index],
        ),
      ),
    );
    // Positioned(
    //   child: appBar(),
    //   top: 0,
    // ),
    // Positioned(
    //   //child: ,
    //   bottom: 0,
    //   right: 20,
    // ),
  }

  // Widget appBar() {
  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     width: MediaQuery.of(context).size.width,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         Image.asset("assets/back_button.png"),
  //         Container(
  //           child: Column(
  //             children: <Widget>[
  //               Text(
  //                 "MEN'S ORIGINAL",
  //                 style: TextStyle(fontWeight: FontWeight.w100, fontSize: 14),
  //               ),
  //               Text(
  //                 "Smiths Shoes",
  //                 style: TextStyle(
  //                     fontSize: 24,
  //                     fontWeight: FontWeight.bold,
  //                     color: Color(0xFF2F2F3E)),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Image.asset(
  //           "assets/bag_button.png",
  //           width: 27,
  //           height: 30,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget spaceVertical(double size) {
    return SizedBox(
      height: size,
    );
  }

  Widget spaceHorizontal(double size) {
    return SizedBox(
      width: size,
    );
  }

  Widget sections() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 5,
            color: Colors.lightGreenAccent,
            child: Text(
              '₹' + listMapq[widget.index]['price'],
              style: TextStyle(fontSize: 28),
            ),
          ),
          description(),
          spaceVertical(20),
          //  property(),
        ],
      ),
    );
  }

  Widget description() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      //padding: EdgeInsets.only(bottom: 50),
      child: Column(
        children: <Widget>[
          Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            listMapq[widget.index]['description'],
            textAlign: TextAlign.justify,
            style: TextStyle(height: 1.5, color: Color(0xFF6F8398)),
          ),
        ],
      ),
    );
  }

  Widget property() {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "COLOR",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2F2F3E)),
              ),
              spaceVertical(10),
              //colorSelector(),
            ],
          ),
          size()
        ],
      ),
    );
  }

  Widget size() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Size",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2F2F3E)),
        ),
        spaceVertical(10),
        Container(
          width: 70,
          padding: EdgeInsets.all(10),
          color: Color(0xFFF5F8FB),
          child: Text(
            "10.1",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F2F3E)),
          ),
        )
      ],
    );
  }

  // Widget  title() {}
}
