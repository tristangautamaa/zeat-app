import 'package:firebase_core/firebase_core.dart';
import 'firestore_setup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'welcome_page.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';
import 'home_page.dart';
import 'chatbot_page.dart';
import 'profile_page.dart';
import 'menu_item_detail_page.dart';
import 'shopping_cart_page.dart';
import 'cart_provider.dart';
import 'admin_login_page.dart';
import 'admin_dashboard_page.dart';
import 'location_page.dart';
import 'menu_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirestoreSetup.initializeData();
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/landing',
      routes: {
        '/landing': (context) => const LandingPage(),
        '/welcome': (context) => const WelcomePage(),
        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/chatbot': (context) => const ChatbotPage(),
        '/profile': (context) => const ProfilePage(),
        '/admin-login': (context) => const AdminLoginPage(),
        '/admin-dashboard': (context) => const AdminDashboardPage(),
        '/location': (context) => const LocationPage(),
        '/menu-list': (context) => const MenuListPage(),
        '/menu-item-detail': (context) {
          final Map<String, dynamic>? itemData =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return MenuItemDetailPage(itemData: itemData);
        },
        '/shopping-cart': (context) => const ShoppingCartPage(),
        '/order-tracking': (context) => const OrderTrackingPage(),
      },
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 500,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bread-landing.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Pay less, Eat More!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Where sweet treats meet sweet deals.\nIndulge in delightful pastries without the guilt or the high price!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              bottom: 50.0,
              left: 16.0,
              right: 16.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/welcome'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  OrderTrackingPageState createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: const Center(
        child: Text('Order placed! Tracking details will appear here.'),
      ),
    );
  }
}
