import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_storage_helper.dart';

class FirestoreSetup {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initializeData() async {
    try {
      // Step 1: Migrate images to Firebase Storage
      final defaultProfileImageUrl =
          await FirebaseStorageHelper.uploadAssetToStorage(
            'assets/user_icon.png', // Replace with your default user icon asset
            'default_images/user_icon.png',
          );
      final placeholderFoodImageUrl =
          await FirebaseStorageHelper.uploadAssetToStorage(
            'assets/placeholder_food.png',
            'default_images/placeholder_food.png',
          );
      // Use placeholderFoodImageUrl if needed, e.g., store it for later use
      await _firestore.collection('default_urls').doc('placeholder_food').set({
        'url': placeholderFoodImageUrl,
      });

      await FirebaseStorageHelper.uploadAssetToStorage(
        'assets/texture-two.png',
        'default_images/texture-two.png',
      );
      await FirebaseStorageHelper.uploadAssetToStorage(
        'assets/texture-three.png',
        'default_images/texture-three.png',
      );
      await FirebaseStorageHelper.uploadAssetToStorage(
        'assets/bread-landing.png',
        'default_images/bread-landing.png',
      );

      // Step 2: Initialize Categories (static data)
      final categories = [
        {'categoryId': 'puff_pastry', 'name': 'Puff Pastry'},
        {'categoryId': 'choux_pastry', 'name': 'Choux Pastry'},
        {'categoryId': 'croissant', 'name': 'Croissant'},
        {'categoryId': 'danish', 'name': 'Danish'},
      ];

      for (var category in categories) {
        await _firestore
            .collection('Categories')
            .doc(category['categoryId'])
            .set(category, SetOptions(merge: true));
      }

      // Step 3: Set up a default user entry (example admin user if not exists)
      final adminUser = {
        'userId': 'admin_user_id', // Replace with actual admin UID after auth
        'name': 'Admin',
        'email': 'admin@zeatapp.com',
        'role': 'admin',
        'profileImageUrl': defaultProfileImageUrl,
      };
      await _firestore
          .collection('Users')
          .doc(adminUser['userId'])
          .set(adminUser, SetOptions(merge: true));
      // Removed print statements
    } catch (e) {
      // Removed print statement, consider using a logging framework in production
    }
  }
}
