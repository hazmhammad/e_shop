import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFromScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Colors.black87, Colors.blue],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.push(context, route);
          },
        ),
        actions: [
          FlatButton(
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                Navigator.push(context, route);
              },
              child: Text(
                "Logout",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
        ],
      ),
      body: getAdminBodyScreen(),
    );
  }

  getAdminBodyScreen() {
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Colors.black87, Colors.blue],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
                child: Text(
                  "Add New Items ",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                color: Colors.blue,
                onPressed: () {
                  takeImage(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Item Image",
              style: TextStyle(
                  color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Capture with camera",
                  style: TextStyle(color: Colors.deepPurpleAccent),
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Select From Gallery",
                  style: TextStyle(color: Colors.deepPurpleAccent),
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.deepPurpleAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      file = imageFile;
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = imageFile;
    });
  }

  displayAdminUploadFromScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
            colors: [Colors.black87, Colors.blue],
            // begin: const FractionalOffset(0.0, 0.0),
            //end: const FractionalOffset(0.1, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: clearFormInfo,
        ),
        title: Text(
          "New product",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          FlatButton(
              onPressed: uploading ? null : () => uploadingImageAndSaveInfo(),
              child: Text(
                "Add",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(file), fit: BoxFit.cover)),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(
              Icons.perm_device_info,
              color: Colors.blue,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(color: Colors.indigo),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.indigo),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_info,
              color: Colors.blue,
            ),
            title: Container(
              width: 250,
              child: TextField(
                  style: TextStyle(color: Colors.indigo),
                  controller: _titleTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Shot info",
                    hintStyle: TextStyle(color: Colors.indigo),
                    border: InputBorder.none,
                  )),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_info,
              color: Colors.blue,
            ),
            title: Container(
              width: 250,
              child: TextField(
                  style: TextStyle(color: Colors.indigo),
                  controller: _descriptionTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(color: Colors.indigo),
                    border: InputBorder.none,
                  )),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_info,
              color: Colors.blue,
            ),
            title: Container(
              width: 250,
              child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.indigo),
                  controller: _priceTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Price",
                    hintStyle: TextStyle(color: Colors.indigo),
                    border: InputBorder.none,
                  )),
            ),
          ),
          Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
    });
  }

  uploadingImageAndSaveInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItmeImage(file);

    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItmeImage(mFileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask =
        storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemsRef = Firestore.instance.collection("Items");
    itemsRef.document(productId).setData({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "title": _titleTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }
}
