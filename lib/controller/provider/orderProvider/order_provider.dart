import 'package:flutter/foundation.dart';
import 'package:uberdriver/model/foodOrderModel/food_order_model.dart';

class OrderProvider extends ChangeNotifier {
  FoodOrderModel? orderData;

  updateFoodOrderData(FoodOrderModel data) {
    orderData = data;
    notifyListeners();
  }

  emptyOrderData() {
    orderData = null;
    notifyListeners();
  }
}
