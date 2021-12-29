import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  ProductPage({this.itemModel});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Image.network(widget.itemModel.thumbnailUrl),
                    ),
                    Container(
                      color: Colors.blueAccent,
                    ),
                    SizedBox(
                      height: 1,
                      width: double.infinity,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.itemModel.title,
                          style: boldTextStyle,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          widget.itemModel.longDescription,
                          style: boldTextStyle,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          r"€" + widget.itemModel.price.toString(),
                          style: boldTextStyle,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: InkWell(
                      onTap: () =>
                          checkItemInCart(widget.itemModel.shortInfo, context),
                      child: Center(
                        child: Container(
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [Colors.black, Colors.black],
                              //begin: const FractionalOffset(0.0, 0.0),
                              //end: const FractionalOffset(0.0, 0.0),
                              tileMode: TileMode.clamp,
                              stops: [0.0, 1.0],
                            ),
                          ),
                          width: MediaQuery.of(context).size.width - 100,
                          height: 50,
                          child: Text(
                            "Add To Cart",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 53,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
