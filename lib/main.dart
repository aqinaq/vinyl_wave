import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'routing/app_router.dart';
import 'services/preferences_service.dart';
import 'state/cart_controller.dart';
import 'state/player_controller.dart';
import 'state/theme_controller.dart';
import 'theme/app_theme.dart';
import 'state/auth_controller.dart';
import 'state/favorites_controller.dart';
import 'state/catalog_filter_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const VinylWaveApp());
}

class VinylWaveApp extends StatefulWidget {
  const VinylWaveApp({super.key});

  @override
  State<VinylWaveApp> createState() => _VinylWaveAppState();
}

class _VinylWaveAppState extends State<VinylWaveApp> {
  final PreferencesService preferencesService = PreferencesService();

  late final ThemeController themeController;
  late final PlayerController playerController;

  @override
  void initState() {
    super.initState();

    themeController = ThemeController(
      preferencesService: preferencesService,
    );

    playerController = PlayerController(
      preferencesService: preferencesService,
    );

    themeController.loadTheme();
    playerController.loadPreferences();
  }

  @override
  void dispose() {
    themeController.dispose();
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PreferencesService>.value(
          value: preferencesService,
        ),
        ChangeNotifierProvider<ThemeController>.value(
          value: themeController,
        ),
        ChangeNotifierProvider<PlayerController>.value(
          value: playerController,
        ),
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(),
        ),
        ChangeNotifierProvider<CatalogFilterController>(
          create: (_) => CatalogFilterController(),
        ),
        ChangeNotifierProvider<CartController>(
          create: (_) {
            final cartController = CartController();
            cartController.loadSavedData();
            return cartController;
          },
        ),
        ChangeNotifierProvider<FavoritesController>(
          create: (_) {
            final favoritesController = FavoritesController();
            favoritesController.loadFavorites();
            return favoritesController;
          },
        ),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          if (themeController.isLoading) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.darkTheme,
              home: const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          final router = createAppRouter();

          return MaterialApp.router(
            title: 'VinylWave',
            debugShowCheckedModeBanner: false,
            theme: themeController.isDarkMode
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}