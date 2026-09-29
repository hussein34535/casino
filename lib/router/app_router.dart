import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:game_show_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:game_show_app/presentation/screens/splash/splash_screen.dart';
import 'package:game_show_app/presentation/screens/main_scaffold.dart';
import 'package:game_show_app/presentation/screens/home/home_screen.dart';
import 'package:game_show_app/presentation/screens/auth/login_screen.dart';
import 'package:game_show_app/presentation/screens/auth/signup_screen.dart';
import 'package:game_show_app/presentation/screens/game_select/game_select_screen.dart';
import 'package:game_show_app/presentation/screens/game/game_screen.dart';
import 'package:game_show_app/presentation/screens/game/game_room_screen.dart';
import 'package:game_show_app/presentation/screens/game/online_entry_screen.dart';
import 'package:game_show_app/presentation/screens/game/game_mode_select_screen.dart';
import 'package:game_show_app/presentation/screens/game/local_setup_screen.dart';
import 'package:game_show_app/presentation/screens/results/results_screen.dart';
import 'package:game_show_app/presentation/screens/profile/profile_screen.dart';
import 'package:game_show_app/presentation/screens/leaderboard/leaderboard_screen.dart';
import 'package:game_show_app/presentation/screens/friends/friends_screen.dart';
import 'package:game_show_app/presentation/screens/achievements/achievements_screen.dart';
import 'package:game_show_app/presentation/screens/settings/settings_screen.dart';
import 'package:game_show_app/presentation/screens/gamification/shop_screen.dart';
import 'package:game_show_app/presentation/screens/gamification/daily_challenges_screen.dart';
import 'package:game_show_app/presentation/screens/gamification/battle_pass_screen.dart';
import 'package:game_show_app/presentation/screens/gamification/rewards_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_dashboard_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_users_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_questions_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_analytics_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_categories_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_moderation_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_settings_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_backup_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_broadcast_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_feedback_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_localization_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_api_keys_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_payment_transactions_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_system_logs_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_achievements_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_game_modes_screen.dart';
import 'package:game_show_app/presentation/screens/admin/admin_leaderboard_screen.dart';
import 'package:game_show_app/presentation/screens/admin/enterprise_admin_screen.dart';
import 'package:game_show_app/presentation/screens/admin/security_dashboard_screen.dart';
import 'package:game_show_app/presentation/screens/admin/monitoring_dashboard_screen.dart';
import 'package:game_show_app/presentation/screens/map/map_screen.dart';
import 'package:game_show_app/presentation/screens/game/buzzer_screen.dart';

Page<void> _buildPageTransition({required Widget child, required GoRouterState state}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 0.05);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(opacity: animation.drive(fadeTween), child: child),
      );
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', name: 'splash', pageBuilder: (context, state) => _buildPageTransition(child: const SplashScreen(), state: state)),
      GoRoute(path: '/onboarding', name: 'onboarding', pageBuilder: (context, state) => _buildPageTransition(child: const OnboardingScreen(), state: state)),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', name: 'home', pageBuilder: (context, state) => _buildPageTransition(child: const HomeScreen(), state: state))]),
          StatefulShellBranch(routes: [GoRoute(path: '/leaderboard', name: 'leaderboard', pageBuilder: (context, state) => _buildPageTransition(child: const LeaderboardScreen(), state: state))]),
          StatefulShellBranch(routes: [GoRoute(path: '/map', name: 'map', pageBuilder: (context, state) => _buildPageTransition(child: const MapScreen(), state: state))]),
          StatefulShellBranch(routes: [GoRoute(path: '/friends', name: 'friends', pageBuilder: (context, state) => _buildPageTransition(child: const FriendsScreen(), state: state))]),
          StatefulShellBranch(routes: [GoRoute(path: '/profile', name: 'profile', pageBuilder: (context, state) => _buildPageTransition(child: const ProfileScreen(), state: state))]),
        ],
      ),
      GoRoute(path: '/login', name: 'login', pageBuilder: (context, state) => _buildPageTransition(child: const LoginScreen(), state: state)),
      GoRoute(path: '/signup', name: 'signup', pageBuilder: (context, state) => _buildPageTransition(child: const SignupScreen(), state: state)),
      GoRoute(path: '/game-modes', name: 'game-modes', pageBuilder: (context, state) => _buildPageTransition(child: const GameModeSelectScreen(), state: state)),
      GoRoute(
        path: '/game-select',
        name: 'game-select',
        pageBuilder: (context, state) => _buildPageTransition(child: const GameSelectScreen(), state: state),
        routes: [
          GoRoute(
            path: ':type',
            name: 'game',
            pageBuilder: (context, state) {
              final type = state.pathParameters['type'] ?? 'trivia';
              final isChangingType = state.extra as bool? ?? false;
              return _buildPageTransition(child: GameScreen(gameType: type, isChangingType: isChangingType), state: state);
            },
            routes: [
              GoRoute(path: 'results', name: 'results', pageBuilder: (context, state) => _buildPageTransition(child: const ResultsScreen(), state: state)),
            ],
          ),
        ],
      ),
      GoRoute(path: '/online', name: 'online', pageBuilder: (context, state) => _buildPageTransition(child: const OnlineEntryScreen(), state: state)),
      GoRoute(path: '/create-room', name: 'create-room', pageBuilder: (context, state) => _buildPageTransition(child: const CreateRoomScreen(), state: state)),
      GoRoute(path: '/waiting-room', name: 'waiting-room', pageBuilder: (context, state) => _buildPageTransition(child: const WaitingRoomScreen(), state: state)),
      GoRoute(path: '/local-setup', name: 'local-setup', pageBuilder: (context, state) => _buildPageTransition(child: const LocalSetupScreen(), state: state)),

      GoRoute(path: '/achievements', name: 'achievements', pageBuilder: (context, state) => _buildPageTransition(child: const AchievementsScreen(), state: state)),
      GoRoute(path: '/settings', name: 'settings', pageBuilder: (context, state) => _buildPageTransition(child: const SettingsScreen(), state: state)),
      GoRoute(path: '/shop', name: 'shop', pageBuilder: (context, state) => _buildPageTransition(child: const ShopScreen(), state: state)),
      GoRoute(path: '/daily-challenges', name: 'daily-challenges', pageBuilder: (context, state) => _buildPageTransition(child: const DailyChallengesScreen(), state: state)),
      GoRoute(path: '/battle-pass', name: 'battle-pass', pageBuilder: (context, state) => _buildPageTransition(child: const BattlePassScreen(), state: state)),
      GoRoute(path: '/rewards', name: 'rewards', pageBuilder: (context, state) => _buildPageTransition(child: const RewardsScreen(), state: state)),

      GoRoute(path: '/buzzer', name: 'buzzer', pageBuilder: (context, state) => _buildPageTransition(child: const BuzzerScreen(), state: state)),
      GoRoute(
        path: '/admin',
        name: 'admin',
        pageBuilder: (context, state) => _buildPageTransition(child: const AdminDashboardScreen(), state: state),
        routes: [
          GoRoute(path: 'users', name: 'admin-users', pageBuilder: (context, state) => _buildPageTransition(child: const AdminUsersScreen(), state: state)),
          GoRoute(path: 'questions', name: 'admin-questions', pageBuilder: (context, state) => _buildPageTransition(child: const AdminQuestionsScreen(), state: state)),
          GoRoute(path: 'analytics', name: 'admin-analytics', pageBuilder: (context, state) => _buildPageTransition(child: const AdminAnalyticsScreen(), state: state)),
          GoRoute(path: 'categories', name: 'admin-categories', pageBuilder: (context, state) => _buildPageTransition(child: const AdminCategoriesScreen(), state: state)),
          GoRoute(path: 'moderation', name: 'admin-moderation', pageBuilder: (context, state) => _buildPageTransition(child: const AdminModerationScreen(), state: state)),
          GoRoute(path: 'settings-page', name: 'admin-settings', pageBuilder: (context, state) => _buildPageTransition(child: const AdminSettingsScreen(), state: state)),
          GoRoute(path: 'backup', name: 'admin-backup', pageBuilder: (context, state) => _buildPageTransition(child: const AdminBackupScreen(), state: state)),
          GoRoute(path: 'broadcast', name: 'admin-broadcast', pageBuilder: (context, state) => _buildPageTransition(child: const AdminBroadcastScreen(), state: state)),
          GoRoute(path: 'feedback', name: 'admin-feedback', pageBuilder: (context, state) => _buildPageTransition(child: const AdminFeedbackScreen(), state: state)),
          GoRoute(path: 'localization', name: 'admin-localization', pageBuilder: (context, state) => _buildPageTransition(child: const AdminLocalizationScreen(), state: state)),
          GoRoute(path: 'api-keys', name: 'admin-api-keys', pageBuilder: (context, state) => _buildPageTransition(child: const AdminApiKeysScreen(), state: state)),
          GoRoute(path: 'payments', name: 'admin-payments', pageBuilder: (context, state) => _buildPageTransition(child: const AdminPaymentTransactionsScreen(), state: state)),
          GoRoute(path: 'system-logs', name: 'admin-system-logs', pageBuilder: (context, state) => _buildPageTransition(child: const AdminSystemLogsScreen(), state: state)),
          GoRoute(path: 'achievements', name: 'admin-achievements', pageBuilder: (context, state) => _buildPageTransition(child: const AdminAchievementsScreen(), state: state)),
          GoRoute(path: 'game-modes', name: 'admin-game-modes', pageBuilder: (context, state) => _buildPageTransition(child: const AdminGameModesScreen(), state: state)),
          GoRoute(path: 'leaderboard', name: 'admin-leaderboard', pageBuilder: (context, state) => _buildPageTransition(child: const AdminLeaderboardScreen(), state: state)),
          GoRoute(path: 'enterprise', name: 'admin-enterprise', pageBuilder: (context, state) => _buildPageTransition(child: const EnterpriseAdminScreen(), state: state)),
          GoRoute(path: 'security', name: 'admin-security', pageBuilder: (context, state) => _buildPageTransition(child: const SecurityDashboardScreen(), state: state)),
          GoRoute(path: 'monitoring', name: 'admin-monitoring', pageBuilder: (context, state) => _buildPageTransition(child: const MonitoringDashboardScreen(), state: state)),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('الصفحة غير موجودة: ${state.error}'),
      ),
    ),
  );
});