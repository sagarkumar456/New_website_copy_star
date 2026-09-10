import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/cart_provider.dart';
import '../../shared/custom_appbar.dart';
import 'package:firebase_database/firebase_database.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const CustomAppBar(),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
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

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: cart.items.length, 
                  itemBuilder: (context, index) {
                    final cartItem = cart.items.values.elementAt(index);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.name,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                        onPressed: () => cart.removeItem(cartItem.id),
                                      ),
                                      Text(
                                        '${cartItem.quantity}',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                        onPressed: () => cart.addItem(cartItem),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.grey),
                              onPressed: () {
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
                        _showCheckoutDialog(context, cart); 
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

  void _showCheckoutDialog(BuildContext context, CartProvider cart) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController landmarkController = TextEditingController();

    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: const Text('Checkout Details', style: TextStyle(color: Colors.white, fontSize: 20)),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTextField(nameController, 'Full Name', Icons.person),
                        const SizedBox(height: 12),
                        _buildTextField(phoneController, 'Phone Number', Icons.phone, keyboardType: TextInputType.phone),
                        const SizedBox(height: 12),
                        _buildTextField(emailController, 'Email ID', Icons.email, keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 12),
                        _buildTextField(addressController, 'Delivery Address', Icons.home),
                        const SizedBox(height: 12),
                        _buildTextField(locationController, 'City / Location', Icons.location_city),
                        const SizedBox(height: 12),
                        _buildTextField(landmarkController, 'Landmark (Optional)', Icons.landscape),
                        const SizedBox(height: 20),
                        
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF63D392).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF63D392)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.money, color: Color(0xFF63D392)),
                              SizedBox(width: 10),
                              Expanded(child: Text('Payment Method: Cash on Delivery (COD)', style: TextStyle(color: Color(0xFF63D392), fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF63D392), foregroundColor: Colors.black),
                  onPressed: isSubmitting ? null : () async {
                    if (formKey.currentState!.validate()) {
                      setState(() => isSubmitting = true);
                      
                      try {
                        List<Map<String, dynamic>> orderItems = [];
                        cart.items.forEach((key, item) {
                          orderItems.add({
                            'item_name': item.name,
                            'quantity': item.quantity,
                          });
                        });

                        final DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('cod_orders').push();
                        await ordersRef.set({
                          'customer_name': nameController.text.trim(),
                          'phone': phoneController.text.trim(),
                          'email': emailController.text.trim(),
                          'address': addressController.text.trim(),
                          'location': locationController.text.trim(),
                          'landmark': landmarkController.text.trim(),
                          'payment_mode': 'COD',
                          'status': 'Pending',
                          'total_quantity': cart.itemCount,
                          'ordered_items': orderItems, 
                          'timestamp': DateTime.now().toIso8601String(),
                        });

                        Navigator.pop(context); // Checkout form band karein
                        
                        // Yahan Success Animation Dialog show hoga
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const OrderSuccessAnimation(),
                        );
                        
                      } catch (e) {
                        setState(() => isSubmitting = false);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
                      }
                    }
                  },
                  child: isSubmitting 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : const Text('Confirm Order', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (label != 'Landmark (Optional)' && (value == null || value.isEmpty)) {
          return 'Please enter $label';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
    );
  }
}

// =========================================================
// ORDER SUCCESS ANIMATION WIDGET
// =========================================================
class OrderSuccessAnimation extends StatefulWidget {
  const OrderSuccessAnimation({super.key});

  @override
  State<OrderSuccessAnimation> createState() => _OrderSuccessAnimationState();
}

class _OrderSuccessAnimationState extends State<OrderSuccessAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: const Icon(Icons.check_circle, color: Colors.green, size: 90),
            ),
            const SizedBox(height: 25),
            const Text(
              'Order Confirmed!', 
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: const Text(
                'Our team will contact you within 1 to 24 hours to confirm your order.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, fontSize: 16, height: 1.4),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF63D392), 
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                ),
                onPressed: () {
                  Navigator.pop(context); // Dialog band karein
                },
                child: const Text('OK, Got it!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}