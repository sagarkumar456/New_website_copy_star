import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/cart_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    
    final currentPath = GoRouterState.of(context).uri.path;
    final isHome = currentPath == '/';

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.2),
      centerTitle: false, 
      titleSpacing: 20, 
      
      leading: (!isHome && isMobile) 
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/'); 
                }
              },
            )
          : null,

      title: InkWell(
        onTap: () => context.go('/'),
        child: Image.asset(
          'assets/videos/images/web_logo.png', 
          height: 45, 
          fit: BoxFit.contain,
          key: const Key('appbar_logo'),
          errorBuilder: (context, error, stackTrace) => const Text(
            'COPYSTAR',
            style: TextStyle(color: Color(0xFF4A90E2), fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2.0),
          ),
        ),
      ),
      
      actions: [
        if (isMobile) ...[
          // Yahan Mobile ke liye Cart Icon add kiya gaya hai
          _buildMobileCartButton(context),
          
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87, size: 30),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ] else ...[
          _buildNavItem(context, 'Home', '/'),
          _buildNavItem(context, 'Services', '/services'),
          _buildNavItem(context, 'Spare Parts', '/parts'),
          _buildNavItem(context, 'Contact', '/contact'),
          const SizedBox(width: 20),
          _buildCartButton(context),
          const SizedBox(width: 20),
        ],
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String route) {
    return TextButton(
      onPressed: () => context.go(route),
      child: Text(title, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  // Desktop View wala bada Cart Button
  Widget _buildCartButton(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF63D392),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () => context.go('/cart'),
          icon: const Icon(Icons.shopping_cart, size: 20),
          label: Text('Cart: ${cart.itemCount} Items'),
        );
      },
    );
  }

  // Mobile View wala chota Cart Icon with Red Badge
  Widget _buildMobileCartButton(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87, size: 26),
              onPressed: () => context.go('/cart'),
            ),
            if (cart.itemCount > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${cart.itemCount}',
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}