// lib/route.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/dashboard/views/dashboard_view.dart';
import 'features/login/views/login_view.dart';
import 'features/tiket_hilang/views/tiket_hilang_view.dart';
import 'features/settings/views/settings_views.dart';
import 'services/secure_storage_service.dart'; // 1. Impor secure storage

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
      builder: (BuildContext context, GoRouterState state) {
        DashboardBinding().dependencies();
        return const DashboardView();
      },
    ),
    GoRoute(
      path: '/lost-ticket',
      builder: (BuildContext context, GoRouterState state) => const LostTicketView(),
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) => const SettingsView(),
    ),
  ],

  // --- PERUBAHAN UTAMA DI SINI ---
  redirect: (BuildContext context, GoRouterState state) async {
    final storage = SecureStorageService();
    // Cek apakah ada data user ID yang tersimpan (menandakan sesi aktif)
    final String? userId = await storage.read('userId');
    final bool isLoggedIn = userId != null && userId.isNotEmpty;

    // Lokasi halaman yang sedang dituju
    final String location = state.matchedLocation;

    // Logika Pengalihan:
    // 1. Jika pengguna BELUM login dan mencoba mengakses halaman selain login
    if (!isLoggedIn && location != '/login') {
      // Alihkan ke halaman login
      return '/login';
    }

    // 2. Jika pengguna SUDAH login dan mencoba mengakses halaman login
    if (isLoggedIn && location == '/login') {
      // Alihkan langsung ke dashboard
      return '/dashboard';
    }

    // 3. Jika tidak ada kondisi di atas, jangan lakukan apa-apa
    return null;
  },
  // --- AKHIR PERUBAHAN ---
);