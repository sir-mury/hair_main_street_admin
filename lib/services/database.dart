import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:hair_main_street_admin/models/admin_variables.dart';
import 'package:hair_main_street_admin/models/cancellation_model.dart';
import 'package:hair_main_street_admin/models/orderModel.dart';
import 'package:hair_main_street_admin/models/userModel.dart';
import 'package:hair_main_street_admin/models/vendorsModel.dart';
import 'package:hair_main_street_admin/models/withdrawalRequest_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hair_main_street_admin/models/productModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class DataBaseService {
  final String? uid;
  DataBaseService({this.uid});

  User? currentUser = FirebaseAuth.instance.currentUser;

  CollectionReference userProfileCollection =
      FirebaseFirestore.instance.collection("userProfile");

  CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  CollectionReference shopsCollection =
      FirebaseFirestore.instance.collection('vendors');

  CollectionReference adminVariablesCollection =
      FirebaseFirestore.instance.collection('admin variables');

  CollectionReference withdrawalRequestCollection =
      FirebaseFirestore.instance.collection('withdrawal requests');

  CollectionReference refundRequestCollection =
      FirebaseFirestore.instance.collection('withdrawal requests');

  CollectionReference cancellationRequestCollection =
      FirebaseFirestore.instance.collection('withdrawal requests');

  //verify role
  Future<Map<String, dynamic>?> verifyRole() async {
    try {
      DocumentSnapshot documentSnapshot =
          await userProfileCollection.doc(currentUser!.uid).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic>? user =
            documentSnapshot.data() as Map<String, dynamic>;
        //print(user);
        if (user["isVendor"] == true) {
          return {"Vendor": currentUser!.uid};
        } else if (user["isBuyer"] == true) {
          return {"Buyer": currentUser!.uid};
        } else {
          throw Exception();
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  //create user profile
  Future createUserProfile({
    required String email,
    required String name,
    required String phone,
    required String address,
  }) async {
    try {
      // Create a cart subcollection
      await userProfileCollection
          .doc(uid)
          .collection('cart')
          .doc(uid)
          .set({'Products': []});

      // Make the user profile
      return await userProfileCollection.doc(uid).set({
        'fullname': name,
        'phonenumber': phone,
        'address': address,
        'isVendor': false,
        'isBuyer': false,
        'isAdmin': true,
      });
    } catch (e) {
      return e;
    }
  }

  //fetch cart products
  Stream<List<dynamic>> fetchCartItems() async* {
    try {
      var role = await verifyRole();
      //print(role);
      if (role!.keys.contains("Buyer")) {
        var result = userProfileCollection
            .doc(role["Buyer"])
            .collection("cart")
            .doc(role["Buyer"])
            .snapshots();
        var test = result;
        yield await test.map((event) {
          var data = event.data() as Map<String, dynamic>;
          //print(data);
          return data["Products"];
        }).toList();
      }
    } catch (e) {
      print(e);
    }

    // Close the Stream.
  }

  //add to cart function
  Future addToCart(Product product) async {
    try {
      var element = FieldValue.arrayUnion([product]);
      var role = await verifyRole();
      if (role!.keys.contains("Buyer")) {
        await userProfileCollection
            .doc(role["Buyer"])
            .collection('cart')
            .doc(role["Buyer"])
            .update({"Products": element});
        return "Success";
      } else {
        print("Not Authorized");
      }
    } catch (e) {
      print(e);
    }
  }

  //create order and update orders

  //image upload for products
  Future<List<dynamic>?> uploadProductImage() async {
    try {
      //actual image
      List<dynamic> productImageList = [];
      dynamic productImage;
      var appDirectoryPath = await getApplicationDocumentsDirectory();
      //pickFile
      final result = await FilePicker.platform.pickFiles(
        //type: FileType.any,
        allowMultiple: true,
        //allowedExtensions: ["png", "jpg", "jpeg"],
      );
      if (result != null) {
        print("result ${result.paths}");
        for (var image in result.files) {
          var targetPath =
              "${appDirectoryPath.path}/compressed_image[${result.files.indexOf(image)}].jpg";
          print("targetPath: $targetPath");
          print("image ${image.path}");
          //compress image
          final compressedImage = await FlutterImageCompress.compressAndGetFile(
            image.path!,
            targetPath,
            quality: 85,
            format: CompressFormat.jpeg,
          );

          //convert to file
          final finalImage = File(compressedImage!.path);
          //firebase Storage reference
          final storageReference = FirebaseStorage.instance.ref("productImage");
          //product images reference
          final productImageReference = storageReference
              .child("compress_image[${result.files.indexOf(image)}]");
          productImage = await productImageReference.putFile(finalImage);
          productImageList.add(productImage);
        }
        return productImageList;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  //create product
  Future addProduct({Product? product}) async {
    try {
      //ensure only user with appropriate role can add product
      //get the current user role
      var role = await verifyRole();
      if (role!.keys.contains("Vendor")) {
        return await productsCollection.doc().set({
          "name": product!.name,
          "price": product.price,
          "image": product.image,
          "hasOption": product.hasOption,
          "allowInstallment": product.allowInstallment,
          "quantity": product.quantity,
          "description": product.description,
          "vendorID": role["Vendor"],
          "createdAt": FieldValue.serverTimestamp(),
          "updatedAt": FieldValue.serverTimestamp(),
        });
      } else {
        print("Not Authorized");
      }
    } catch (e) {
      print("catch error $e");
    }
  }

  //update product
  Future updateProduct({String? fieldName, dynamic value, id}) async {
    try {
      //ensure only user with appropriate role can add product
      //get the current user role
      var role = await verifyRole();
      if (role!.keys.contains("Vendor")) {
        return await productsCollection.doc(id).update({"$fieldName": value});
      } else {
        print("Not Authorized");
      }
    } catch (e) {
      print(e);
    }
  }

  //convert to product
  List<Product?> convertToProduct(QuerySnapshot<Object?> products) {
    if (products.docs.isEmpty) {}
    return products.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Product.fromdata(data);
    }).toList();
  }

  List<MyUser?> convertToUser(QuerySnapshot<Object?> users) {
    if (users.docs.isEmpty) {
      return []; // Return an empty list if no documents are found
    }

    return users.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      try {
        MyUser user = MyUser.fromdata(data);
        return user;
      } catch (e) {
        print("Error converting user: $e");
        return null;
      }
    }).toList();
  }

  List<Orders?> convertToOrder(QuerySnapshot<Object?> orders) {
    print('convert');
    return orders.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Orders.fromJson(data);
    }).toList();
  }

  //fetch products
  Stream<List<Product?>> fetchProducts() {
    var stuff = productsCollection.snapshots();
    //print(stuff);
    return stuff.map(
      (event) => convertToProduct(event),
    );
  }

  //fetch users
  Stream<List<MyUser?>> fetchUsers() {
    var users = userProfileCollection.snapshots();
    //print(stuff);
    return users.map(
      (user) => convertToUser(user),
    );
  }

  //fetch a single users delivery addresses
  Stream<List<Address>> fetchDeliveryAddress(String userID) {
    // Fetch delivery addresses synchronously
    Stream<List<Address>> address = userProfileCollection
        .doc(userID)
        .collection('delivery addresses')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Address.fromJson(doc.data()))
          .toList();
    });

    return address;
  }

  //fetch single product
  Future fetchSingleProduct(dynamic id) async {
    DocumentSnapshot snapshot = await productsCollection.doc(id).get();
    if (snapshot.exists) {
      var product = snapshot.data() as Product;
      print(product);
      product.vendorId = id;
      print(product);
      return product;
    }
  }

  Stream<List<Orders>> getOrders() {
    try {
      return ordersCollection.snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => Orders.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      }).asBroadcastStream();
    } catch (e) {
      print("Error fetching orders: $e");
      return Stream.value([]);
    }
  }

  // Add the following method to your existing DatabaseService class
  Stream<List<Vendors>> getShops() {
    try {
      return shopsCollection.snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => Vendors.fromData(doc.data() as Map<String, dynamic>))
            .toList();
      }).asBroadcastStream();
    } catch (e) {
      print("Error fetching orders: $e");
      return Stream.value([]);
    }
  }

  List<Vendors?> convertToVendors(QuerySnapshot<Object?> shops) {
    if (shops.docs.isEmpty) {}
    return shops.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return Vendors.fromData(data);
    }).toList();
  }

  Future<void> updateShop(Vendors shop) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('vendors').doc(shop.userID);
    final DocumentSnapshot docSnapshot = await documentReference.get();
    if (docSnapshot.exists) {
      await documentReference.update(shop.toData());
    } else {
      await documentReference.set(shop.toData());
    }
  }

  //admin settings
  //get admin variables
  Future<AdminVariables> getAdminVariables() async {
    try {
      var data = await adminVariablesCollection.doc('admin').get();
      if (data.exists) {
        return AdminVariables.fromJson(data.data() as Map<String, dynamic>);
      } else {
        throw Exception("Admin variables dont exist");
      }
    } catch (e) {
      print(e);
      throw Exception("Failed to get admin variables");
    }
  }

  //modify an admin variable
  Future modifyAdminVariable(String fieldName, dynamic fieldValue,
      {String? operation}) async {
    try {
      if (operation == "add category") {
        await adminVariablesCollection.doc('admin').set({
          fieldName: fieldName == "categories"
              ? FieldValue.arrayUnion(fieldValue)
              : fieldValue
        }, SetOptions(merge: true));
      } else if (operation == "delete category") {
        await adminVariablesCollection.doc('admin').set({
          fieldName: fieldName == "categories"
              ? FieldValue.arrayRemove(fieldValue)
              : fieldValue
        }, SetOptions(merge: true));
      } else {
        await adminVariablesCollection.doc('admin').set({
          fieldName: fieldValue,
        }, SetOptions(merge: true));
      }
      return 'success';
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  //payment stuff
  //Get vendors withdrawal requests
  Stream<List<WithdrawalRequest>> getWithdrawalRequests() {
    var data = withdrawalRequestCollection.snapshots();
    return data.map(
      (snapshot) => snapshot.docs.map((doc) {
        return WithdrawalRequest.fromJson(doc.data() as Map<String, dynamic>);
      }).toList(),
    );
  }

  //Get cancellation requests
  Stream<List<CancellationRequest>> getCancellationRequests() {
    var data = cancellationRequestCollection.snapshots();
    return data.map(
      (snapshot) => snapshot.docs.map((doc) {
        return CancellationRequest.fromData(doc.data() as Map<String, dynamic>);
      }).toList(),
    );
  }

  //Get refund requests
  Stream<List<WithdrawalRequest>> getRefundRequests() {
    var data = refundRequestCollection.snapshots();
    return data.map(
      (snapshot) => snapshot.docs.map((doc) {
        return WithdrawalRequest.fromJson(doc.data() as Map<String, dynamic>);
      }).toList(),
    );
  }

  //referral

  //chats
}
