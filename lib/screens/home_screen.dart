import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/slide_up_animation.dart';
import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/player_screen.dart';
import '../state/cart_controller.dart';
import '../state/player_controller.dart';
import '../state/theme_controller.dart';

enum SidePanelType {
  cart,
  orders,
}

class HomeScreen extends StatefulWidget {
  final Widget child;

  const HomeScreen({
    super.key,
    required this.child,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SidePanelType selectedPanel = SidePanelType.cart;

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/store')) {
      return 1;
    }

    if (location.startsWith('/profile')) {
      return 2;
    }

    return 0;
  }

  bool _isStorePage(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return location.startsWith('/store');
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/store');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  void openSidePanel(SidePanelType panelType) {
    setState(() {
      selectedPanel = panelType;
    });

    scaffoldKey.currentState?.openEndDrawer();
  }

  void openPlayerBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.92,
          minChildSize: 0.45,
          maxChildSize: 0.98,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Now Playing',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                const Expanded(
                  child: PlayerScreen(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final isStorePage = _isStorePage(context);

    final themeController = context.watch<ThemeController>();
    final cartController = context.watch<CartController>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('VinylWave'),
        actions: [
          IconButton(
            onPressed: themeController.toggleTheme,
            icon: Icon(
              themeController.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {
                  openSidePanel(SidePanelType.cart);
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              Positioned(
                right: 6,
                top: 8,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: cartController.itemCount == 0
                      ? const SizedBox(
                    key: ValueKey('empty-cart-badge'),
                  )
                      : CircleAvatar(
                    key: ValueKey(cartController.itemCount),
                    radius: 9,
                    child: Text(
                      '${cartController.itemCount}',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      body: widget.child,

      endDrawer: _RightSidePanel(
        panelType: selectedPanel,
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isStorePage)
            _StoreBottomActions(
              onCartPressed: () {
                openSidePanel(SidePanelType.cart);
              },
              onOrdersPressed: () {
                openSidePanel(SidePanelType.orders);
              },
            ),

          SlideUpAnimation(
            delay: const Duration(milliseconds: 150),
            child: _MiniPlayerBar(
              onTap: openPlayerBottomSheet,
            ),
          ),

          NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              _onDestinationSelected(context, index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Icon(Icons.storefront_outlined),
                selectedIcon: Icon(Icons.storefront),
                label: 'Store',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RightSidePanel extends StatelessWidget {
  final SidePanelType panelType;

  const _RightSidePanel({
    required this.panelType,
  });

  String get title {
    switch (panelType) {
      case SidePanelType.cart:
        return 'Cart';
      case SidePanelType.orders:
        return 'My Orders';
    }
  }

  Widget get content {
    switch (panelType) {
      case SidePanelType.cart:
        return const CartScreen();
      case SidePanelType.orders:
        return const OrdersScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final drawerWidth = screenWidth >= 700 ? 420.0 : screenWidth * 0.92;

    return Drawer(
      width: drawerWidth,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreBottomActions extends StatelessWidget {
  final VoidCallback onCartPressed;
  final VoidCallback onOrdersPressed;

  const _StoreBottomActions({
    required this.onCartPressed,
    required this.onOrdersPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<CartController>();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.4),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onOrdersPressed,
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text('Orders'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onCartPressed,
              icon: const Icon(Icons.shopping_cart_outlined),
              label: Text(
                cartController.itemCount == 0
                    ? 'Cart'
                    : 'Cart (${cartController.itemCount})',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniPlayerBar extends StatelessWidget {
  final VoidCallback onTap;

  const _MiniPlayerBar({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final playerController = context.watch<PlayerController>();

    final currentTrack = playerController.currentTrack;
    final currentAlbum = playerController.currentAlbum;

    final String trackTitle =
        playerController.currentTrack?.title ?? 'No track selected';

    final String albumTitle =
        playerController.currentAlbum?.title ?? 'Tap to open player';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.4),
            ),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: Icon(
                playerController.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trackTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    albumTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_up),
          ],
        ),
      ),
    );
  }
}