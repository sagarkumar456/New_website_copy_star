import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; 
import 'package:firebase_database/firebase_database.dart'; // 🟢 Added Firebase
import '../../core/cart_provider.dart'; 
import '../../shared/custom_appbar.dart';

// 🟢 UPDATED: Helper Model class to support Firebase data (added price)
class ProductItem {
  final String id;
  final String title;
  final String spec;
  final String subName;
  final String imagePath;
  final double price;

  const ProductItem({
    required this.id,
    required this.title,
    required this.spec,
    required this.subName,
    required this.imagePath,
    required this.price,
  });
}

class PartsCatalogScreen extends StatelessWidget {
  const PartsCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth < 600 ? 15.0 : 40.0;
    double spacing = screenWidth < 600 ? 15.0 : 20.0;
    
    double availableWidth = screenWidth - (padding * 2);
    int itemsPerRow;
    if (availableWidth >= 1300) {
      itemsPerRow = 4; 
    } else if (availableWidth >= 850) {
      itemsPerRow = 2; 
    } else {
      itemsPerRow = 1; 
    }

    double cardWidth = (availableWidth - (spacing * (itemsPerRow - 1))) / itemsPerRow;
    cardWidth = cardWidth - 0.1; 

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), 
      appBar: const CustomAppBar(),
      endDrawer: _buildMobileDrawer(context),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            const Text(
              'Spare Parts Catalog',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
            ),
            const SizedBox(height: 40),

            // 🟢 NAYA: Firebase StreamBuilder for Live CRM Products
            StreamBuilder(
              stream: FirebaseDatabase.instance.ref().child('products').onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: CircularProgressIndicator(color: Color(0xFF58C485)),
                    )
                  );
                }
                
                if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                  return const Center(
                    child: Text('No products available right now.', style: TextStyle(color: Colors.grey, fontSize: 18))
                  );
                }

                Map<dynamic, dynamic> productsMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                Map<String, List<ProductItem>> groupedProducts = {};

                productsMap.forEach((key, value) {
                  var prod = Map<String, dynamic>.from(value);
                  
                  if (prod['is_active'] == true) { // Sirf active products dikhayenge
                    String category = prod['category'] ?? 'Other Parts';
                    
                    // CRM data ko aapke ProductItem design mein map kar rahe hain
                    ProductItem item = ProductItem(
                      id: key,
                      title: prod['name'] ?? 'Unknown Product',
                      spec: prod['description'] ?? 'Standard Part',
                      subName: prod['name'] ?? '', // Subname aur title same rakha hai CRM sync ke liye
                      imagePath: prod['image_url'] ?? '',
                      price: double.tryParse(prod['price'].toString()) ?? 0.0,
                    );

                    if (!groupedProducts.containsKey(category)) {
                      groupedProducts[category] = [];
                    }
                    groupedProducts[category]!.add(item);
                  }
                });

                // Categories ko alphabetical sort karna
                List<String> categories = groupedProducts.keys.toList();
                categories.sort();

                return Column(
                  children: categories.map((category) {
                    return _buildCategorySection(
                      category, 
                      groupedProducts[category]!, 
                      context, 
                      cardWidth, 
                      spacing
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // MOBILE DRAWER MENU
  // ==========================================
  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF121212)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'COPYSTAR',
                  style: TextStyle(color: Color(0xFF4A90E2), fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2.0),
                ),
                SizedBox(height: 10),
                Text('Navigation Menu', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () { Navigator.pop(context); context.go('/'); },
          ),
          ListTile(
            leading: const Icon(Icons.build, color: Colors.white),
            title: const Text('Services', style: TextStyle(color: Colors.white)),
            onTap: () { Navigator.pop(context); context.go('/services'); },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Spare Parts', style: TextStyle(color: Colors.white)),
            onTap: () { Navigator.pop(context); context.go('/parts'); },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail, color: Colors.white),
            title: const Text('Contact', style: TextStyle(color: Colors.white)),
            onTap: () { Navigator.pop(context); context.go('/contact'); },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.shopping_cart, color: Color(0xFF63D392)),
            title: const Text('View Cart', style: TextStyle(color: Color(0xFF63D392), fontWeight: FontWeight.bold)),
            onTap: () { Navigator.pop(context); context.go('/cart'); },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<ProductItem> products, BuildContext context, double cardWidth, double spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 25),
        Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: WrapAlignment.start, 
          children: products.map((p) => _buildProductCard(context, p, cardWidth, title)).toList(),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _build3DPlaceholder(String categoryTitle) {
    IconData iconData = Icons.print;
    Color iconColor = Colors.blueAccent;

    if (categoryTitle.toLowerCase().contains('toner')) {
      iconData = Icons.water_drop; 
      iconColor = Colors.cyan;
    } else if (categoryTitle.toLowerCase().contains('chip')) {
      iconData = Icons.memory; 
      iconColor = Colors.teal;
    } else if (categoryTitle.toLowerCase().contains('drum')) {
      iconData = Icons.change_circle; 
      iconColor = Colors.deepOrange;
    } else if (categoryTitle.toLowerCase().contains('belt') || categoryTitle.toLowerCase().contains('roller')) {
      iconData = Icons.settings; 
      iconColor = Colors.deepPurple;
    }

    return Container(
      height: 80,
      width: 80,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade300],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          iconData,
          size: 40,
          color: iconColor,
          shadows: const [
            Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4)
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductItem product, double cardWidth, String categoryTitle) {
    
    // 🟢 Image Logic: Check if it's a web URL from Firebase or a local asset
    Widget imageWidget;
    if (product.imagePath.startsWith('http')) {
      imageWidget = Container(
        height: 80, width: 80, margin: const EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(product.imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => _build3DPlaceholder(categoryTitle)),
        ),
      );
    } else if (product.imagePath.isNotEmpty) {
      imageWidget = Container(
        height: 80, width: 80, margin: const EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(product.imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => _build3DPlaceholder(categoryTitle)),
        ),
      );
    } else {
      imageWidget = _build3DPlaceholder(categoryTitle); // Agar koi image nahi dali CRM se
    }

    return Container(
      width: cardWidth, 
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageWidget, // Naya image logic yahan apply kiya hai
          const SizedBox(width: 20), 

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title, 
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1976D2), height: 1.2), 
                ),
                const SizedBox(height: 8),
                
                Text(
                  'For Use In : ${product.spec}', 
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.4), 
                ),
                
                // 🟢 Price dikhane ke liye
                const SizedBox(height: 8),
                Text(
                  '₹${product.price.toStringAsFixed(0)}', 
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                
                Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    final int qty = cart.getQuantity(product.title);

                    if (qty == 0) {
                      return SizedBox(
                        width: double.infinity,
                        height: 36, 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF58C485), 
                            foregroundColor: Colors.white,
                            elevation: 0, 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          onPressed: () {
                            // 🟢 CRM price ke sath cart mein add hoga
                            final newItem = CartItem(
                              id: product.title, 
                              name: product.title,
                              price: product.price, 
                              imageUrl: product.imagePath,
                              quantity: 1,
                            );
                            
                            cart.addItem(newItem);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.title} added to cart!'),
                                backgroundColor: Colors.green,
                                duration: const Duration(milliseconds: 1500),
                              ),
                            );
                          },
                          child: const Text('Buy Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      );
                    } 
                    else {
                      return Container(
                        height: 36,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF58C485), width: 1.5),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.remove, color: Color(0xFF58C485), size: 20),
                              onPressed: () {
                                cart.removeItem(product.title);
                              },
                            ),
                            
                            Text(
                              '$qty',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.add, color: Color(0xFF58C485), size: 20),
                              onPressed: () {
                                final newItem = CartItem(
                                  id: product.title,
                                  name: product.title,
                                  price: product.price,
                                  imageUrl: product.imagePath,
                                  quantity: 1,
                                );
                                cart.addItem(newItem);
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}