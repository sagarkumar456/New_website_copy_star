import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens Imports

import '../features/home/home_screen.dart';
import '../features/spare_parts/parts_catalog_screen.dart';
import '../features/cart/cart_screen.dart'; 
import '../features/contact/contact_screen.dart';   // NAYA CONTACT IMPORT
import '../features/services/services_screen.dart'; // NAYA SERVICES IMPORT

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(key: Key('home_route')),
    ),
    GoRoute(
      path: '/parts',
      builder: (context, state) => const PartsCatalogScreen(key: Key('parts_route')),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(key: Key('cart_route')),
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) => const ServicesScreen(key: Key('services_route')),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactScreen(key: Key('contact_route')),
    ),
  ],
);