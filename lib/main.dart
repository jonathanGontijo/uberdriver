import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:uberdriver/controller/provider/authProvider/auth_provider.dart';
import 'package:uberdriver/controller/provider/orderProvider/order_provider.dart';
import 'package:uberdriver/controller/provider/profileProvider/profile_provider.dart';
import 'package:uberdriver/controller/provider/rideProvider/rider_provider.dart';
import 'package:uberdriver/firebase_options.dart';
import 'package:uberdriver/view/signInLogicScreen/sign_in_logic_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DriverEats());
}

class DriverEats extends StatelessWidget {
  const DriverEats({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, _, __) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<MobileAuthProvider>(
            create: (_) => MobileAuthProvider(),
          ),
          ChangeNotifierProvider<ProfileProvider>(
            create: (_) => ProfileProvider(),
          ),
          ChangeNotifierProvider<RideProvider>(
            create: (_) => RideProvider(),
          ),
          ChangeNotifierProvider<OrderProvider>(
            create: (_) => OrderProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(),
          home: const SignInLogicScreen(),
        ),
      );
    });
  }
}
