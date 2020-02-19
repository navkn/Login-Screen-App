import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_screen_app/Model/usefulData.dart';
import 'package:login_screen_app/pages/single_product_page.dart';

class ProdTile extends StatefulWidget {
  final int index;

  ProdTile(this.index);
  @override
  _ProdTile createState() => _ProdTile();
}

class _ProdTile extends State<ProdTile> {
  Uint8List imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = null;
    print('init state');
    // print(indexes);
    // print(listMap);
    print(mapOfImagesq.keys);
    if (indexesq.contains(widget.index)) {
      setState(() {
        imageFile = mapOfImagesq[widget.index];
      });
    } else {
      // print(listMap[widget.index]['images']);
      getImage(widget.index, listMapq[widget.index]['images']);
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
    return InkResponse(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          print(140);
          return SingleProductPage(widget.index);
        }));
      },
      child: Column(children: [
        Expanded(
          child: Card(
            color: Colors.grey,
            child: decideImage(),
          ),
        ),
        Text(listMapq[widget.index]['title']),
        Text('₹'+listMapq[widget.index]['price']),
      ]),
    );
  }

  void getImage(int index, String url) {
    //  print(url);
    if (!indexesq.contains(index)) {
      downloadImage(url).then((val) {
        if (!mapOfImagesq.containsKey(index)) {
          mapOfImagesq[index] = val;
        }
        print(mapOfImagesq.keys);
        indexesq.add(index);
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
        mapOfImagesq[widget.index],
        fit: BoxFit.cover,
      );
    } else {
      return Center(
        child: Text('Loading!!!'),
      );
    }
  }
}
