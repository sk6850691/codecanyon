import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_course/scr/helpers/order.dart';
import 'package:food_course/scr/helpers/screen_navigation.dart';
import 'package:food_course/scr/models/cart_item.dart';
import 'package:food_course/scr/providers/app.dart';
import 'package:food_course/scr/providers/user.dart';
import 'package:food_course/scr/screens/order.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart'as http;
import 'package:uuid/uuid.dart';

import 'cart.dart';
import 'home.dart';
class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();
  Razorpay _razorPay;
  int money = int.parse('0');

  static String paymentApiUrl= 'https://api.stripe.com/v1/payment_intents';
  static String secret = "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";
  static Map<String,String>headers = {
    'Authorization': 'Bearer ${secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,_handlePaymentSuccess);
    StripePayment.setOptions(
        StripeOptions(
        publishableKey: "pk_live_51HIU66GRLEy3JrONmIypoSwNeJjOm2l5jBQ1MLXqzbLmpdwMXjuLlB0vrJCk6vyyyo9Dv9txwtcBrb5Egxgzl8rR00O9tB0Nz3",
        merchantId: "Test",
        androidPayMode: 'test'));
  }
  _handlePaymentSuccess(){

  }
  void opencheckout()async{

    var options = {
    'key': 'rzp_live_gaXCq7KjMpUGcm',
    'amount': money,
    'name': 'shubhkaran',
    'description': 'fjnjf',
    'prefill': {'contact': 7527910117,'email': 'ss@gmail.com'},
    'external':{'wallets':['paytm']

    }};
    _razorPay.open(options);
  }

  Future payWithNewcard({String amount,String currency})async{

  }
  static Future<Map<String,dynamic>> hcreatePaymentIntent(String amount,String currency)async{
    try{
      Map<String,dynamic> body = {
        'amount': amount,
        'currency':currency,
        'payment_method_types[]':'card'
      };
      var response = await http.post(
          Uri.parse(paymentApiUrl),
          body:body,
          headers: headers

      );
      return jsonDecode(response.body);
    }catch(e){print(e);}
  }






  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);
    return Scaffold(floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: (){
        print(user.userModel.totalCartPrice.toString());
      },
    ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          MaterialButton(
            color: Colors.red,


            onPressed: opencheckout,
            child: Text('Pay with Razorpay'),
          ),
          MaterialButton(
            onPressed: ()async{
              try{
                 Future<Map<String,dynamic>> createPaymentIntent(String amount,String currency)async{
                  try{
                    Map<String,dynamic> body = {
                      'amount': amount,
                      'currency':currency,
                      'payment_method_types[]':'card'
                    };
                    var response = await http.post(
                        Uri.parse(paymentApiUrl),
                        body:body,
                        headers: headers

                    );
                    return jsonDecode(response.body);
                  }catch(e){print(e);}
                }





                var paymentMethod = await StripePayment.paymentRequestWithCardForm(
                    CardFormPaymentRequest()
                );
                var paymentIntent = await createPaymentIntent(user.userModel.totalCartPrice.toString(),'INR');
                var response = await StripePayment.confirmPaymentIntent(
                    PaymentIntent(
                        clientSecret: paymentIntent['client_secret'],
                        paymentMethodId: paymentMethod.id
                    )
                );
                if(response.status == 'succeeded') {
                  print('gjfgjfhgjf');

                  var uuid = Uuid();
                  String id = uuid.v4();
                  _orderServices.createOrder(
                      userId: user.user.uid,
                      id: id,
                      description: "Some random description",
                      status: "complete",
                      totalPrice: user.userModel.totalCartPrice,
                      cart: user.userModel.cart
                  );
                  Navigator.pop(context);
                  setState(() {
                    changeScreen(context,OrdersScreen());
                  });

                  app.changeLoading();




                  for (CartItemModel cartItem in user.userModel.cart) {
                    bool value = await user.removeFromCart(cartItem: cartItem);
                    if (value) {
                      user.reloadUserModel();
                      print("Item added to cart");
                      _key.currentState.showSnackBar(
                          SnackBar(content: Text("Removed from Cart!"))
                      );
                    } else {
                      print("ITEM WAS NOT REMOVED");
                    }
                  }
                  _key.currentState.showSnackBar(
                      SnackBar(content: Text("Order created!"))
                  );




                }


              }


              catch(e){print('hi'+ e);}






            },

              child:Text('Pay with Stripe')
          )],
      ),
    );
  }
}
