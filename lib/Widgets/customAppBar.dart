import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.black87, Colors.blue],
            //begin: const FractionalOffset(0.0, 0.0),
            //end: const FractionalOffset(0.0, 0.0),
            tileMode: TileMode.clamp,
            stops: [0.0, 1.0],
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        "e-shope",
        style: TextStyle(
            color: Colors.white, fontSize: 55, fontFamily: "Signatra"),
      ),
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => CartPage());
                  Navigator.pushReplacement(context, route);
                }),
            Positioned(
                child: Stack(
              children: [
                Icon(
                  Icons.brightness_1,
                  size: 20,
                  color: Colors.white,
                ),
                Positioned(
                  top: 17,
                  bottom: 4,
                  child:
                      Consumer<CartItemCounter>(builder: (context, counter, _) {
                    return Text(
                      counter.count.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    );
                  }),
                )
              ],
            ))
          ],
        )
      ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
