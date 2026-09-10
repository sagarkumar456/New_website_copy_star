import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // Added for navigation
import '../../core/cart_provider.dart'; 
import '../../shared/custom_appbar.dart';

// Helper Model class for Products
class ProductItem {
  final String title;
  final String spec;
  final String subName;
  final String imagePath;

  const ProductItem({
    required this.title,
    required this.spec,
    required this.subName,
    required this.imagePath,
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
      
      // ==========================================
      // ADDED END DRAWER HERE FOR MOBILE MENU
      // ==========================================
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

            _buildCategorySection('Color Toner (Kg)(CMYK)', [
              const ProductItem(title: 'Cyan Toner (1Kg) - Copystar', spec: 'Konica Minolta C1085/C1100', subName: 'Cyan Toner (1000grm)', imagePath: 'assets/videos/services-full_image/toner image/Cyan Toner (1Kg) - Copystar.jpeg'),
              const ProductItem(title: 'Magenta Toner (1Kg) - Copystar', spec: 'Konica Minolta C1085/C1100', subName: 'Magenta Toner (1000grm)', imagePath: 'assets/videos/services-full_image/toner image/Magenta Toner (1Kg) - Copystar.jpeg'),
              const ProductItem(title: 'Yellow Toner (1Kg) - Copystar', spec: 'Konica Minolta C1085/C1100', subName: 'Yellow Toner (1000grm)', imagePath: 'assets/videos/services-full_image/toner image/Yellow Toner (1Kg) - Copystar.jpeg'),
              const ProductItem(title: 'Black Toner (1Kg) - Copystar', spec: 'Konica Minolta C1085/C1100', subName: 'Black Toner (1000grm)', imagePath: 'assets/videos/services-full_image/toner image/Black Toner (1Kg) - Copystar.jpeg'),
            ], context, cardWidth, spacing),

            _buildCategorySection('Toner Cartridge (CMYK)', [
              const ProductItem(title: 'Yellow Toner Cartridge', spec: 'Konica Minolta C258 / C308 / C358', subName: 'Yellow Toner Cartridge', imagePath: 'assets/videos/services-full_image/CARTRIDGE image/CARTRIDGE Yellow.png'),
              const ProductItem(title: 'Magenta Toner Cartridge', spec: 'Konica Minolta C258 / C308 / C358', subName: 'Magenta Toner Cartridge', imagePath: 'assets/videos/services-full_image/CARTRIDGE image/CARTRIDGE Magenta.png'),
              const ProductItem(title: 'Cyan Toner Cartridge', spec: 'Konica Minolta C258 / C308 / C358', subName: 'Cyan Toner Cartridge', imagePath: 'assets/videos/services-full_image/CARTRIDGE image/CARTRIDGE Cyan.png'),
              const ProductItem(title: 'Black Toner Cartridge', spec: 'Konica Minolta C258 / C308 / C358', subName: 'Black Toner Cartridge', imagePath: 'assets/videos/services-full_image/CARTRIDGE image/CARTRIDGE Black.png'),
            ], context, cardWidth, spacing),

            _buildCategorySection('Toner Cartridge (CMYK) - XEROX Dc240-700i', [
              const ProductItem(title: 'Yellow Toner Cartridge- 220V', spec: 'XEROX Wc7525 / 7530 / 7535 / 7545 / 7556\nWc7830 / 7835 / 7845 / 7855', subName: 'Yellow Toner Cartridge', imagePath: 'assets/videos/services-full_image/cartridge xrox/Yellow Toner Cartridge.png'),
              const ProductItem(title: 'Magenta Toner Cartridge (220v)', spec: 'XEROX Wc7525 / 7530 / 7535 / 7545 / 7556\nWc7830 / 7835 / 7845 / 7855', subName: 'Magenta Toner Cartridge', imagePath: 'assets/videos/services-full_image/cartridge xrox/Magenta Toner Cartridge.png'),
              const ProductItem(title: 'Cyan Toner Cartridge (220v)', spec: 'XEROX Wc7525 / 7530 / 7535 / 7545 / 7556\nWc7830 / 7835 / 7845 / 7855', subName: 'Cyan Toner Cartridge', imagePath: 'assets/videos/services-full_image/cartridge xrox/Cyan Toner Cartridge.png'),
              const ProductItem(title: 'Black Toner Cartridge (220v)', spec: 'XEROX Wc7525 / 7530 / 7535 / 7545 / 7556\nWc7830 / 7835 / 7845 / 7855', subName: 'Black Toner Cartridge', imagePath: 'assets/videos/services-full_image/cartridge xrox/Black Toner Cartridge.png'),
            ], context, cardWidth, spacing),

            _buildCategorySection('Toner Chip (CMYK)', [
              const ProductItem(title: 'Cyan Toner Chip (220v)', spec: 'XEROX Wc7525 / 7530 / 7535 / 7545 / 7556\nWc7830 / 7835 / 7845 / 7855', subName: 'Cyan Toner Chip', imagePath: 'assets/videos/services-full_image/Toner Chip/Toner Chip.png'),
              const ProductItem(title: 'Magenta Toner Chip (220v)', spec: 'XEROX Wc7525 / 7530 / 7535 / 7545 / 7556\nWc7830 / 7835 / 7845 / 7855', subName: 'Magenta Toner Chip', imagePath: 'assets/videos/services-full_image/Toner Chip/Toner Chip.png'),
              const ProductItem(title: 'Yellow Toner Chip (220v)', spec: 'XEROX Wc7525 / 7530 / 7535 / 7545 / 7556\nWc7830 / 7835 / 7845 / 7855', subName: 'Yellow Toner Chip', imagePath: 'assets/videos/services-full_image/Toner Chip/Toner Chip.png'),
              const ProductItem(title: 'Black Toner Chip (220v)', spec: 'XEROX Wc7525 / 7530 / 7535 / 7545 / 7556\nWc7830 / 7835 / 7845 / 7855', subName: 'Black Toner Chip', imagePath: 'assets/videos/services-full_image/Toner Chip/Toner Chip.png'),
            ], context, cardWidth, spacing),
            
            _buildCategorySection('Opc Drum', [
              const ProductItem(title: 'Opc Drum - Color', spec: 'XEROX Dc240 / 242 / 250 / 252 / 260', subName: 'Opc Drum - Color', imagePath: 'assets/videos/services-full_image/Opc Drum/Opc Drum - Color.png'),
              const ProductItem(title: 'Opc Drum - Black', spec: 'XEROX Dc240 / 242 / 250 / 252 / 260', subName: 'Opc Drum - Black', imagePath: 'assets/videos/services-full_image/Opc Drum/Opc Drum - Black.png'),
              const ProductItem(title: 'Opc Drum', spec: 'Konica Minolta C5500, C6500, C6501 OPC', subName: 'Opc Drum', imagePath: 'assets/videos/services-full_image/Opc Drum/Konica Minolta.png'),
              const ProductItem(title: 'Opc Drum', spec: 'Konica Minolta C258 / C308 / C358 Long Life OPC Drum', subName: 'Opc Drum', imagePath: 'assets/videos/services-full_image/Opc Drum/Konica Minolta C258.png'),
            ], context, cardWidth, spacing),

            _buildCategorySection('IBT Belt', [
              const ProductItem(title: 'C258 IBT Belt', spec: 'Konica Minolta C258 / C308 / C358 IBT BELT', subName: 'IBT BELT', imagePath: 'assets/videos/services-full_image/belt/Konica Minolta belt.png'),
              const ProductItem(title: 'C5500 IBT Belt', spec: 'Konica Minolta C5500, C6500, C6501 IBT Belt', subName: 'IBT Belt', imagePath: 'assets/videos/services-full_image/belt/Konica Minolta belt.png'),
              const ProductItem(title: 'Wc7525 IBT Belt', spec: 'XEROX Wc7525 / 7530 / 7535 / 7545 / 7556\nWc7830 / 7835 / 7845 / 7855', subName: 'IBT Belt', imagePath: 'assets/videos/services-full_image/belt/Konica Minolta belt.png'),
              const ProductItem(title: 'Dc240 IBT Belt', spec: 'XEROX Dc240 / 242 / 250 / 252 / 260', subName: 'IBT Belt', imagePath: 'assets/videos/services-full_image/belt/Konica Minolta belt.png'),
            ], context, cardWidth, spacing),

            _buildCategorySection('Fuser Film', [
              const ProductItem(title: 'Dc240 Fuser Film', spec: 'XEROX Dc240 / 242 / 250 / 252 / 260\nDc550 / 560 / 700 / 700i', subName: 'Dc240 Fuser Film', imagePath: 'assets/videos/services-full_image/XEROX Fuser Film/XEROX Fuser FilmDc240.png'),
              const ProductItem(title: 'Wc7525 Fuser Film', spec: 'XEROX Wc7525 / 7530 / 7535 / 7545 / 7556\nWc7830 / 7835 / 7845 / 7855', subName: 'Wc7525 Fuser Film', imagePath: 'assets/videos/services-full_image/XEROX Fuser Film/Fuser Film Wc7525.png'),
              const ProductItem(title: 'C6000 Fuser Film', spec: 'Konica Minolta C1085, C1100, C70hc', subName: 'C6000 Fuser Film', imagePath: 'assets/videos/services-full_image/XEROX Fuser Film/Konica Minolta Fuser FilmC1085.png'),
              const ProductItem(title: 'C258 Fuser Film', spec: 'Konica Minolta C258 / C308 / C358', subName: 'C258 Fuser Film', imagePath: 'assets/videos/services-full_image/XEROX Fuser Film/C258 Fuser Film.png'),
            ], context, cardWidth, spacing),

            _buildCategorySection('Fuser Roller & Lower Roller', [
              const ProductItem(title: 'Dc240 Fuser Roller', spec: 'Xerox Dc240, Dc242, Dc250, DC252, Dc260', subName: 'Dc240 Fuser Roller', imagePath: 'assets/videos/services-full_image/Roller/Xerox Fuser RollerDc240.png'),
              const ProductItem(title: 'Wc7525 Fuser Roller', spec: 'XEROX Wc7425 / Wc7428 / Wc7435', subName: 'Wc7525 Fuser Roller', imagePath: 'assets/videos/services-full_image/Roller/Fuser Roller Wc7425.png'),
              const ProductItem(title: 'C258 Lower Roller', spec: 'Konica Minolta C258 / C308 / C358', subName: 'C258 Lower Roller', imagePath: 'assets/videos/services-full_image/Roller/LOWER ROLLERC258.png'),
              const ProductItem(title: 'C6500 Fusing Roller', spec: 'Konica Minolta C5500, C6500, C6501', subName: 'C6500 Fusing Roller', imagePath: 'assets/videos/services-full_image/Roller/C6501 Fusing Roller.png'),
            ], context, cardWidth, spacing),
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
          _build3DPlaceholder(categoryTitle),
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
                const SizedBox(height: 8),

                Text(
                  product.subName, 
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
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
                            final newItem = CartItem(
                              id: product.title, 
                              name: product.title,
                              price: 0.0, 
                              imageUrl: product.imagePath,
                              quantity: 1,
                            );
                            
                            cart.addItem(newItem);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.subName} added to cart!'),
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
                                  price: 0.0,
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