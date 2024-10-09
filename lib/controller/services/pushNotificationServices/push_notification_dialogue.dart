// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:uberdriver/constants/constant.dart';
import 'package:uberdriver/controller/provider/orderProvider/order_provider.dart';
import 'package:uberdriver/controller/provider/rideProvider/rider_provider.dart';
import 'package:uberdriver/controller/services/locationServices.dart/location_services.dart';
import 'package:uberdriver/controller/services/orderServices/order_services.dart';
import 'package:uberdriver/controller/services/profileServices/profile_services.dart';
import 'package:uberdriver/model/driverModel/driver_model.dart';
import 'package:uberdriver/model/foodOrderModel/food_order_model.dart';
import 'package:uberdriver/utils/colors.dart';
import 'package:uberdriver/utils/text_styles.dart';

class PushNotificationDialogue {
  static deliveryRequestDialogue(String orderID, BuildContext context) async {
    DeliveryPartnerModel deliveryPartnerData =
        await ProfileServices.getDeliveryPartnerProfileData();
    if (deliveryPartnerData.activeDeliveryRequestID == null) {
      audioPlayer.setAsset('assets/sounds/alert.mp3');
      audioPlayer.play();
      FoodOrderModel foodOrderData =
          await OrderServices.fetchOrderDetails(orderID);
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: SizedBox(
                height: 50.h,
                width: 90.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Request',
                        style: AppTextStyles.body18Bold,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Pickup Location: \t\t',
                                style: AppTextStyles.body14Bold),
                            TextSpan(
                                text: foodOrderData
                                    .resturantDetails.restaurantName,
                                style: AppTextStyles.body14),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Delivery Location: \t\t',
                                style: AppTextStyles.body14Bold),
                            TextSpan(
                                text: foodOrderData.userAddress!.apartment,
                                style: AppTextStyles.body14),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SwipeButton(
                        thumbPadding: EdgeInsets.all(1.w),
                        thumb: Icon(Icons.chevron_right, color: white),
                        inactiveThumbColor: black,
                        activeThumbColor: black,
                        inactiveTrackColor: greyShade3,
                        activeTrackColor: greyShade3,
                        elevationThumb: 2,
                        elevationTrack: 2,
                        onSwipe: () {
                          audioPlayer.stop();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Skip',
                          style: AppTextStyles.body14Bold,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SwipeButton(
                        thumbPadding: EdgeInsets.all(1.w),
                        thumb: Icon(Icons.chevron_right, color: white),
                        inactiveThumbColor: black,
                        activeThumbColor: black,
                        inactiveTrackColor: Colors.green.shade200,
                        activeTrackColor: Colors.green.shade200,
                        elevationThumb: 2,
                        elevationTrack: 2,
                        onSwipe: () async {
                          Position deliveryGuyPosition =
                              await LocationServices.getCurretnLocation();
                          LatLng deliveryGuy = LatLng(
                            deliveryGuyPosition.latitude,
                            deliveryGuyPosition.longitude,
                          );
                          LatLng resturant = LatLng(
                            foodOrderData.resturantDetails.address!.latitude!,
                            foodOrderData.resturantDetails.address!.longitude!,
                          );
                          LatLng delivery = LatLng(
                            foodOrderData.userAddress!.latitude,
                            foodOrderData.userAddress!.longitude,
                          );
                          context.read<RideProvider>().updateDeliveryLatLngs(
                                deliveryGuy,
                                resturant,
                                delivery,
                              );
                          OrderServices
                              .updateDiverProfileIntoFoodOrderModelNAddActiveDeliveryRequest(
                                  orderID, context);
                          context
                              .read<RideProvider>()
                              .fetchCrrLocationToResturantPoliline(context);
                          context
                              .read<RideProvider>()
                              .fetchResturantToDeliveryPoliline(context);
                          FoodOrderModel orderData =
                              await OrderServices.fetchOrderDetails(orderID);
                          context
                              .read<RideProvider>()
                              .updateOrderData(orderData);
                          context
                              .read<OrderProvider>()
                              .updateFoodOrderData(orderData);
                          context
                              .read<RideProvider>()
                              .updateInDeliveryStatus(true);
                          context.read<RideProvider>().updateMarker(context);
                          audioPlayer.stop();

                          Navigator.pop(context);
                        },
                        child: Text(
                          'Accept',
                          style: AppTextStyles.body14Bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }
}
