import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/cart_provider.dart';
import '../../shared/custom_appbar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const CustomAppBar(),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          // Agar cart khali hai
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey.shade400),
                  const SizedBox(height: 20),
                  Text(
                    'Your Cart is Empty',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                  ),
                ],
              ),
            );
          }

          // Agar cart mein items hain
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: cart.items.length, // Total unique items
                  itemBuilder: (context, index) {
                    // Yahan hume direct CartItem object mil raha hai
                    final cartItem = cart.items.values.elementAt(index);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            // Product Image
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                cartItem.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => 
                                  Icon(Icons.print, color: Colors.grey.shade400, size: 40),
                              ),
                            ),
                            const SizedBox(width: 20),
                            
                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.name,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  // Quantity Controls
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                        // Decrease quantity (id/name pass karna hai)
                                        onPressed: () => cart.removeItem(cartItem.id),
                                      ),
                                      Text(
                                        '${cartItem.quantity}',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                        // Increase quantity (Poora CartItem pass karna hai)
                                        onPressed: () => cart.addItem(cartItem),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            // Optional: Delete Button (direct remove)
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.grey),
                              onPressed: () {
                                // Ek hi baar mein item clear karne ke liye logic
                                while(cart.getQuantity(cartItem.id) > 0) {
                                  cart.removeItem(cartItem.id);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Bottom Checkout Bar
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Items:', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        Text(
                          '${cart.itemCount} Units',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF63D392),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        // Checkout Button Logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Proceeding to Checkout...')),
                        );
                      },
                      child: const Text('Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}