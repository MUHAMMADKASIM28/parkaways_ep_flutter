// lib/route.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'features/dashboard/views/dashboard_view.dart';
import 'features/login/views/login_view.dart';
import 'features/tiket_hilang/views/tiket_hilang_view.dart';
import 'features/settings/views/settings_views.dart';
import 'services/secure_storage_service.dart';
import 'features/qris/views/qris_payment_view.dart';

/// Konfigurasi rute aplikasi.
final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => const LoginView(),
    ),
    GoRoute(
      path: '/dashboard',
      // --- PERUBAHAN DI SINI ---
      // Kita bungkus DashboardView dengan sebuah Builder
      // untuk memastikan binding dijalankan sebelum view dibuat.
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: Builder(builder: (context) {
            // Jalankan binding di sini
            DashboardBinding().dependencies();
            return const DashboardView();
          }),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Anda bisa menggunakan transisi fade atau biarkan default
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    // --- AKHIR PERUBAHAN ---
    GoRoute(
      path: '/lost-ticket',
      builder: (BuildContext context, GoRouterState state) => const LostTicketView(),
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) => const SettingsView(),
    ),

    GoRoute(
      path: '/qris-payment',
      builder: (BuildContext context, GoRouterState state) {
        // Mengambil data yang dikirim dari halaman dashboard
        final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
        return QrisPaymentView(paymentData: data);
      },
    ),
  ],

  redirect: (BuildContext context, GoRouterState state) async {
    final storage = SecureStorageService();
    final String? userId = await storage.read('userId');
    final bool isLoggedIn = userId != null && userId.isNotEmpty;

    final String location = state.matchedLocation;

    if (!isLoggedIn && location != '/login') {
      return '/login';
    }

    if (isLoggedIn && location == '/login') {
      return '/dashboard';
    }

    return null;
  },
);