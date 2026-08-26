// lib/core/services/session_service.dart
//
// Lightweight singleton that persists the authenticated user's role to
// shared_preferences.  This gives the router guard a reliable, synchronous
// source of truth that is independent of the Supabase JWT metadata (which may
// be stale or missing).
//
// Lifecycle:
//   • saveRole(role)   — called by AuthBloc after a successful sign-in or
//                        session check, before navigating away from LoginPage.
//   • clearSession()   — called on sign-out, before navigating to /login.
//   • cachedRole       — read synchronously by the router guard.

import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SessionService {
  SessionService._();
  static final SessionService instance = SessionService._();

  static const _kRoleKey = 'cached_user_role';

  // In-memory mirror so the guard never blocks the UI thread.
  UserRole? _cachedRole;
  UserRole? get cachedRole => _cachedRole;

  // ── Called once at app start (in di.init()) ─────────────────
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_kRoleKey);
    if (stored != null) {
      _cachedRole = UserRole.fromString(stored);
    }
  }

  // ── Persist role after successful login / session restore ────
  Future<void> saveRole(UserRole role) async {
    _cachedRole = role;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kRoleKey, role.name);
  }

  // ── Wipe on sign-out ─────────────────────────────────────────
  Future<void> clearSession() async {
    _cachedRole = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kRoleKey);
  }
}
