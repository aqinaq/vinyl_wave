import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/album_detail_screen.dart';
import '../screens/album_list_screen.dart';
import '../screens/album_not_found_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/home_screen.dart';
import '../screens/not_found_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/store_screen.dart';
import '../services/album_repository_provider.dart';
import '../state/cart_controller.dart';

GoRouter createAppRouter() {
  final albumRepository = createAlbumRepository();

  return GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) {
      return const NotFoundScreen();
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return const AlbumListScreen();
            },
          ),
          GoRoute(
            path: '/store',
            builder: (context, state) {
              return const StoreScreen();
            },
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) {
              return const ProfileScreen();
            },
          ),
        ],
      ),

      GoRoute(
        path: '/album/:id',
        builder: (context, state) {
          final albumId = state.pathParameters['id'];

          return FutureBuilder(
            future: albumRepository.getAlbumById(albumId ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final album = snapshot.data;

              if (album == null) {
                return AlbumNotFoundScreen(albumId: albumId);
              }

              return AlbumDetailScreen(
                album: album,
              );
            },
          );
        },
      ),

      GoRoute(
        path: '/checkout',
        redirect: (context, state) {
          final cartController = context.read<CartController>();

          if (cartController.isLoading) {
            return null;
          }

          if (cartController.items.isEmpty) {
            return '/store';
          }

          return null;
        },
        builder: (context, state) {
          return const CheckoutScreen();
        },
      ),
    ],
  );
}