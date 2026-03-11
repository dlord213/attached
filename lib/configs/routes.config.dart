import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../screens/auth/login.dart';
import '../screens/auth/register.dart';
import '../screens/auth/forgot_password.dart';
import '../screens/home/home.dart';
import '../screens/onboarding/onboarding.dart';
import '../screens/invitation/invitation.dart';
import '../services/auth.provider.dart';

import '../screens/landing/landing.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuth = authState != null;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation == '/landing';

      if (!isAuth && !isAuthRoute) return '/landing';

      if (isAuth) {
        final hasPartner = authState.hasPartner;
        final isOnboardingRoute = state.matchedLocation == '/onboarding';
        final isInvitationRoute = state.matchedLocation == '/invitation';

        if (hasPartner != true && !isOnboardingRoute && !isInvitationRoute)
          return '/onboarding';
        if (hasPartner == true && (isOnboardingRoute || isInvitationRoute))
          return '/';
        if (isAuthRoute) return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/invitation',
        builder: (context, state) {
          return const InvitationPage();
        },
      ),
    ],
  );
});
