import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_course/scr/models/adressmodel.dart';
import 'package:food_course/scr/models/cart_item.dart';
import 'package:food_course/scr/models/user.dart';

class UserServices{
  String collection = "users";
  FirebaseFirestore _FirebaseFirestore = FirebaseFirestore.instance;

  void createUser(Map<String, dynamic> values) {
    String id = values["id"];
    _FirebaseFirestore.collection(collection).doc(id).set(values);
  }

  void updateUserData(Map<String, dynamic> values){
    _FirebaseFirestore.collection(collection).doc(values['id']).update(values);
  }


  void addToCart({String userId, CartItemModel cartItem}){
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _FirebaseFirestore.collection(collection).doc(userId).update({
      "cart": FieldValue.arrayUnion([cartItem.toMap()])
    });
  }
  void addLocation({String userId,String location}){
    _FirebaseFirestore.collection(collection).doc(userId).update({
      "adrress":location
    });
  }
  Future getLocation({String userId}){
    _FirebaseFirestore.collection(collection).where("uid",isEqualTo:userId ).get().then((result){
      List<Address> location =[];
      for(DocumentSnapshot snapshot in result.docs){

        location.add(Address.fromSnapshot(snapshot));

      }
      return location;


    });

}



  void removeFromCart({String userId, CartItemModel cartItem}){
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _FirebaseFirestore.collection(collection).doc(userId).update({
      "cart": FieldValue.arrayRemove([cartItem.toMap()])
    });
  }


  Future<UserModel> getUserById(String id) => _FirebaseFirestore.collection(collection).doc(id).get().then((doc){
    return UserModel.fromSnapshot(doc);
  });
}