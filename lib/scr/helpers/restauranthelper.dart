import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurantmodel.dart';

class RestaurantServices {
  String collection = "restaurants";
  FirebaseFirestore _FirebaseFirestore = FirebaseFirestore.instance;

  Future<List<RestaurantModel>> getRestaurants() async =>
      _FirebaseFirestore.collection(collection).get().then((result) {
        List<RestaurantModel> restaurants = [];
        for(DocumentSnapshot restaurant in result.docs){
          restaurants.add(RestaurantModel.fromSnapshot(restaurant));
        }
        return restaurants;
      });

  Future<RestaurantModel> getRestaurantById({String id}) => _FirebaseFirestore.collection(collection).doc(id.toString()).get().then((doc){
    return RestaurantModel.fromSnapshot(doc);
  });

  Future<List<RestaurantModel>> searchRestaurant({String restaurantName}) {
    // code to convert the first character to uppercase
    String searchKey = restaurantName[0].toUpperCase() + restaurantName.substring(1);
    return _FirebaseFirestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .get()
        .then((result) {
      List<RestaurantModel> restaurants = [];
      for (DocumentSnapshot product in result.docs) {
        restaurants.add(RestaurantModel.fromSnapshot(product));
      }
      return restaurants;
    });
  }
}