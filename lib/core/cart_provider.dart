import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ==========================================
// CART ITEM MODEL
// ==========================================
class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  // Firebase mein save karne ke liye data ko Map me convert karna padta hai
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }
}

// ==========================================
// CART PROVIDER LOGIC
// ==========================================
class CartProvider extends ChangeNotifier {
  // Map use karenge: { 'Product Name' : CartItem Object }
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  // Total kitne items hain cart mein
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  // Kisi specific item ki quantity pata karne ke liye
  int getQuantity(String partName) {
    return _items[partName]?.quantity ?? 0;
  }

  // Item add karna ya quantity badhana (+)
  void addItem(CartItem item) {
    if (_items.containsKey(item.id)) {
      _items[item.id]!.quantity += 1;
    } else {
      _items[item.id] = item;
    }
    notifyListeners(); // UI ko turant update karega
    _syncCartToFirebase(); // <--- FIREBASE API CALL
  }

  // Item remove karna ya quantity ghatana (-)
  void removeItem(String partName) {
    if (!_items.containsKey(partName)) return;
    
    if (_items[partName]!.quantity > 1) {
      _items[partName]!.quantity -= 1;
    } else {
      _items.remove(partName); 
    }
    notifyListeners();
    _syncCartToFirebase(); // <--- FIREBASE API CALL
  }

  // Cart poori clear karne ke liye
  void clearCart() {
    _items.clear();
    notifyListeners();
    _syncCartToFirebase();
  }

  // ==========================================
  // FIREBASE BACKEND SYNC LOGIC
  // ==========================================
  Future<void> _syncCartToFirebase() async {
    try {
      // Firebase pe upload karne se pehle sabhi CartItem objects ko Map me badalna hoga
      Map<String, dynamic> firestoreItems = {};
      _items.forEach((key, item) {
        firestoreItems[key] = item.toMap();
      });

      // 'carts' naam ka collection banega
      // Abhi testing ke liye hum ek fix document 'guest_session' use kar rahe hain
      await FirebaseFirestore.instance.collection('carts').doc('guest_session').set({
        'cart_items': firestoreItems, // Converted map yahan pass kiya
        'total_items': itemCount,
        'last_updated': FieldValue.serverTimestamp(), // Exact time record karega
      });
      debugPrint('Cart successfully synced to Firebase Database!');
    } catch (e) {
      debugPrint('Firebase Sync Error: $e');
    }
  }
}