import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_screen_app/Model/usefulData.dart';


class CartProdTile extends StatefulWidget {
  final int index;

  CartProdTile(this.index);
  @override
  _CartProdTile createState() => _CartProdTile();
}

class _CartProdTile extends State<CartProdTile> {
  Uint8List imageFile;
  //int quantity;
  @override
  void initState() {
    super.initState();
    imageFile = null;
    //quantity=0;
   // qty[widget.index]=0;
   // print('ond:'+qty.elementAt(widget.index));
    print('init state');
    // print(indexes);
    // print(listMap);
    print(cartProdData);
    print(cartImages.keys);
    if (cartItemIndexes.contains(widget.index)) {
      setState(() {
        imageFile = cartImages[widget.index];
      });
    } else {
      // print(listMap[widget.index]['images']);
      getImage(widget.index, cartProdData[widget.index]['images']);
    }
  }

  @override
  Widget build(BuildContext context) {
    //  return ListTile(

    //     leading: Card(
    //       color: Colors.grey,
    //       child: Container(
    //         width: (MediaQuery.of(context).size.width) *0.1,
    //         child: decideImage()),
    //     ),
    //     title: Text(listMapq[widget.index]['title'],textScaleFactor: 1.2,),
    //     subtitle: Text('\₹'+listMapq[widget.index]['price']),
    //     onTap: (){
    //       Navigator.push(context,
    //                           MaterialPageRoute(builder: (BuildContext context) {
    //                         print(140);
    //                         return SingleProductPage(widget.index);
    //                       }));
    //     },
    //   );
    return
        //  InkResponse(
        // onTap: () {
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (BuildContext context) {
        //   //  print(140);
        //     // listOfDocumentsq.forEach((f) {
        //     //   print('doc ids:'+f.documentID);
        //     // });
        //    // print("doc id is:" + listOfDocumentsq[widget.index].documentID);
        //     //print('uid:'+cartUId);

        //     return SingleProductPage(widget.index);
        //   }));
        // },
        // child:
        ListTile(
      leading: Container(
        child: decideImage(),
        width: MediaQuery.of(context).size.width * 0.3,
      ),
      title: Text(cartProdData[widget.index]['title']),
      subtitle: Text('₹' + cartProdData[widget.index]['price']),
      trailing: customFloatButton(),
      //RaisedButton(onPressed: null, child: Icon(Icons.delete)),
      //       child: Row(children: [
      //   Expanded(
      //     child: Card(
      //       color: Colors.grey,
      //       child: ,
      //     ),
      //   ),

      // ]),
    )
        //)
        ;
  }

  void getImage(int index, String url) {
    //  print(url);
    if (!cartItemIndexes.contains(index)) {
      downloadImage(url).then((val) {
        if (!cartImages.containsKey(index)) {
          cartImages[index] = val;
        }
        print(cartImages.keys);
        cartItemIndexes.add(index);
        setState(() {
          imageFile = val;
        });
      }).catchError((e) {
        print('error in downloading image');
      });
    }
  }

  Future<Uint8List> downloadImage(String url) async {
    try {
      http.Response response = await http.get(
        url,
      );
      return response.bodyBytes;
    } catch (e) {
      //    print(e);
      throw e;
    }
  }

  Widget decideImage() {
    if (imageFile != null) {
      return Image.memory(
        cartImages[widget.index],
        fit: BoxFit.cover,
      );
    } else {
      return Center(
        child: Text('Loading!!!'),
      );
    }
  }

  Widget customFloatButton() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Row(
        children: <Widget>[
          Expanded(
              //width: MediaQuery.of(context).size.width * 0.1,
              flex: 3,
              child: Card(
                child: InkResponse(
                  child: Icon(
                    Icons.add,
                    color: Colors.green,
                  ),
                  onTap: () {
                    // setState(() {
                    //   qty[widget.index]=qty[widget.index]+1;
                    // });
                  },
                ),
              )
              // RaisedButton(
              //   onPressed: () {
              //     setState(() {
              //       quantity++;
              //     });
              //   },
              //   child: Icon(Icons.add),
              // ),
              ),
          // Expanded(
          //     flex: 1,
          //     //  width: MediaQuery.of(context).size.width * 0.1,
          //     child: Text(qty[widget.index].toString())),
          Expanded(
              flex: 3,
              // width: MediaQuery.of(context).size.width * 0.1,
              child: Card(
                child: InkResponse(
                  child: Icon(
                    Icons.remove,
                    color: Colors.deepOrange,
                  ),
                  onTap: () {
                    // setState(() {
                    //   qty[widget.index]=qty[widget.index]-1;
                    //   print(qty[widget.index]);
                    // });
                  },
                ),
              )
              // RaisedButton(
              //   onPressed: () {
              //     setState(() {
              //       quantity--;
              //     });
              //   },
              //   child: Icon(Icons.minimize),
              // ),
              )
        ],
      ),
    );
  }
}
