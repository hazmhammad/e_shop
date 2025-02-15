import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: MediaQuery.of(context).size,

      child: Drawer(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 100, bottom: 40),
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                colors: [Colors.black87, Colors.blue],
                //begin: const FractionalOffset(0.0, 0.0),
                //end: const FractionalOffset(0.0, 0.0),
                tileMode: TileMode.clamp,
                stops: [0.0, 1.0],
              )),
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(80)),
                    elevation: 8,
                    child: Container(
                        height: 160,
                        width: 160,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            EcommerceApp.sharedPreferences
                                .getString(EcommerceApp.userAvatarUrl),
                          ),
                        )),
                  ),
                  SizedBox(height: 10),
                  Text(
                    EcommerceApp.sharedPreferences
                        .getString(EcommerceApp.userName),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontFamily: "Signatra"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.only(top: 1),
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                colors: [Colors.black87, Colors.blue],
                //begin: const FractionalOffset(0.0, 0.0),
                //end: const FractionalOffset(0.0, 0.0),
                tileMode: TileMode.clamp,
                stops: [0.0, 1.0],
              )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Home",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => StoreHome());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(
                    height: 20,
                    color: Colors.white,
                    thickness: 6,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.reorder,
                      color: Colors.white,
                    ),
                    title: Text(
                      "MyOrder",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => MyOrders());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(
                    height: 20,
                    color: Colors.white,
                    thickness: 6,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    title: Text(
                      "MyCart",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(
                    height: 20,
                    color: Colors.white,
                    thickness: 6,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    title: Text(
                      "search",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => SearchProduct());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(
                    height: 20,
                    color: Colors.white,
                    thickness: 6,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.add_location,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Add New Address",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Route route =
                          MaterialPageRoute(builder: (c) => AddAddress());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(
                    height: 20,
                    color: Colors.white,
                    thickness: 6,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      EcommerceApp.auth.signOut().then((c) {
                        Route route = MaterialPageRoute(
                            builder: (c) => AuthenticScreen());
                        Navigator.pushReplacement(context, route);
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
