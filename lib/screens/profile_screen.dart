import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/preferences_service.dart';
import '../state/auth_controller.dart';
import '../state/favorites_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String preferredGenre = 'K-Pop';
  bool isLoading = true;
  bool didLoad = false;
  bool isSignUpMode = false;

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final List<String> genres = const [
    'K-Pop',
    'Hip-Hop',
    'Pop',
    'R&B',
    'Anthology',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!didLoad) {
      didLoad = true;
      loadPreferredGenre();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loadPreferredGenre() async {
    final preferencesService = context.read<PreferencesService>();
    final savedGenre = await preferencesService.getPreferredGenre();

    if (!mounted) return;

    setState(() {
      preferredGenre = savedGenre;
      isLoading = false;
    });
  }

  Future<void> updatePreferredGenre(String? genre) async {
    if (genre == null) return;

    final preferencesService = context.read<PreferencesService>();

    setState(() {
      preferredGenre = genre;
    });

    await preferencesService.savePreferredGenre(genre);
  }

  Future<void> submitAuthForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final authController = context.read<AuthController>();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (isSignUpMode) {
      await authController.signUpWithEmail(
        email: email,
        password: password,
      );
    } else {
      await authController.signInWithEmail(
        email: email,
        password: password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final favoritesController = context.watch<FavoritesController>();

    if (isLoading || authController.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final user = authController.user;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const CircleAvatar(
          radius: 48,
          child: Icon(Icons.person, size: 48),
        ),

        const SizedBox(height: 16),

        Text(
          user == null ? 'Welcome to VinylWave' : 'BTS Vinyl Collector',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        const SizedBox(height: 8),

        Text(
          user == null
              ? 'Sign in, create an account, or continue as guest.'
              : user.isAnonymous
              ? 'Signed in as guest'
              : 'Signed in with email',
          textAlign: TextAlign.center,
        ),

        if (user != null) ...[
          const SizedBox(height: 8),
          SelectableText(
            user.isAnonymous
                ? 'Guest User ID: ${user.uid}'
                : 'Email: ${user.email}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],

        const SizedBox(height: 24),

        if (user == null)
          _AuthCard(
            formKey: formKey,
            emailController: emailController,
            passwordController: passwordController,
            isSignUpMode: isSignUpMode,
            errorMessage: authController.errorMessage,
            onSubmit: submitAuthForm,
            onToggleMode: () {
              authController.clearError();

              setState(() {
                isSignUpMode = !isSignUpMode;
              });
            },
            onGuestPressed: () {
              authController.signInAnonymously();
            },
          )
        else
          OutlinedButton.icon(
            onPressed: () {
              authController.signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
          ),

        const SizedBox(height: 24),

        Card(
          child: ExpansionTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorite Albums'),
            subtitle: Text(
              favoritesController.favoriteAlbums.isEmpty
                  ? 'No favorite albums yet.'
                  : '${favoritesController.favoriteAlbums.length} saved album(s).',
            ),
            children: [
              for (final album in favoritesController.favoriteAlbums)
                ListTile(
                  leading: const Icon(Icons.album),
                  title: Text(album.title),
                  subtitle: Text(album.genre),
                ),
            ],
          ),
        ),

        Card(
          child: ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Orders'),
            subtitle: const Text('Open Orders from the Store page.'),
            onTap: () {},
          ),
        ),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: preferredGenre,
              decoration: const InputDecoration(
                labelText: 'Preferred genre',
                border: OutlineInputBorder(),
              ),
              items: genres.map((genre) {
                return DropdownMenuItem(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
              onChanged: updatePreferredGenre,
            ),
          ),
        ),

        Card(
          child: ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Saved Preferences'),
            subtitle: Text('Preferred genre: $preferredGenre'),
          ),
        ),
      ],
    );
  }
}

class _AuthCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSignUpMode;
  final String? errorMessage;
  final VoidCallback onSubmit;
  final VoidCallback onToggleMode;
  final VoidCallback onGuestPressed;

  const _AuthCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isSignUpMode,
    required this.errorMessage,
    required this.onSubmit,
    required this.onToggleMode,
    required this.onGuestPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                isSignUpMode ? 'Create Account' : 'Sign In',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your email';
                  }

                  if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your password';
                  }

                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }

                  return null;
                },
              ),

              if (errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onSubmit,
                  icon: Icon(
                    isSignUpMode ? Icons.person_add : Icons.login,
                  ),
                  label: Text(
                    isSignUpMode ? 'Sign Up' : 'Sign In',
                  ),
                ),
              ),

              const SizedBox(height: 8),

              TextButton(
                onPressed: onToggleMode,
                child: Text(
                  isSignUpMode
                      ? 'Already have an account? Sign in'
                      : 'New here? Create an account',
                ),
              ),

              const Divider(height: 28),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onGuestPressed,
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Continue as Guest'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}