import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_screen_app/Model/usefulData.dart';

class ProductGridTile extends StatefulWidget {
  final int index;

  ProductGridTile(this.index);
  @override
  _ProductGridTileState createState() => _ProductGridTileState();
}

class _ProductGridTileState extends State<ProductGridTile> {
  Uint8List imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = null;
    print('init state');
    // print(indexes);
    // print(listMap);
    print(mapOfImages.keys);
    if (indexes.contains(widget.index)) {
      setState(() {
        imageFile = mapOfImages[widget.index];
      });
    } else {
      // print(listMap[widget.index]['images']);
      getImage(widget.index, listMap[widget.index]['images']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: Card(
          color: Colors.grey,
          child: decideImage(),
        ),
      ),
      Text(listMap[widget.index]['title']),
      Text('₹'+listMap[widget.index]['price']),
    ]);
  }

  void getImage(int index, String url) {
    //  print(url);
    if (!indexes.contains(index)) {
      downloadImage(url).then((val) {
        if (!mapOfImages.containsKey(index)) {
          mapOfImages[index] = val;
        }
        print(mapOfImages.keys);
        indexes.add(index);
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
        mapOfImages[widget.index],
        fit: BoxFit.cover,
      );
    } else {
      return Center(
        child: Text('Loading!!!'),
      );
    }
  }
}
