// lib/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/dashboard/views/dashboard_view.dart';
import 'features/login/views/login_view.dart';
import 'features/tiket_hilang/views/tiket_hilang_view.dart';
import 'features/settings/views/settings_views.dart'; // 1. Impor file settings_views.dart

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
    // 2. Tambahkan rute baru untuk halaman pengaturan
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) => const SettingsView(),
    ),
  ],
);