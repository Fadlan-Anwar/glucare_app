import 'package:flutter/foundation.dart';
import '../../core/constants/api_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';
import 'custom_user.dart';
import '../../core/user_provider.dart';
import '../home/dashboard_screen.dart';

// Provider untuk AuthService singleton
final authServiceProvider = Provider((ref) {
  return AuthService();
});

// Provider untuk listen perubahan auth state (login/logout)
final authStateChangesProvider = StreamProvider<CustomUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return () async* {
    yield authService.currentUser;
    yield* authService.authStateChanges;
  }();
});

// Provider untuk mendapatkan user ID jika sudah login
final userIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateChangesProvider).value;
  return authState?.uid;
});

// Provider untuk mendapatkan current user info
final currentUserProvider = Provider<CustomUser?>((ref) {
  final authState = ref.watch(authStateChangesProvider).value;
  return authState;
});

// Provider untuk status login
final isLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(userIdProvider);
  return user != null;
});

// Provider untuk fetch user profile dari database berdasarkan session saat ini
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  // Watch auth state changes so we fetch fresh database profile when session changes
  final authState = ref.watch(authStateChangesProvider).value;
  if (authState == null) {
    // User logged out, clear the profile in UserProvider immediately
    UserProvider.clearProfile();
    return null;
  }

  try {
    final authService = ref.watch(authServiceProvider);
    final userData = await authService.fetchUserData();
    
    if (userData != null) {
      final imagePath = userData['profile_image'];
      String? profileImageUrl;
      if (imagePath != null && imagePath.toString().isNotEmpty) {
        profileImageUrl = imagePath.toString().startsWith('http')
            ? imagePath.toString()
            : '${ApiConfig.baseUrl}$imagePath';
      }
      
      UserProvider.updateProfile(
        name: userData['fullname'] ?? userData['fullName'] ?? authState.displayName ?? '',
        email: userData['email'] ?? authState.email ?? '',
        gender: userData['gender'] ?? '',
        phone: userData['phone'] ?? '',
        birthDate: userData['birth_date'] ?? '',
        profileImageUrl: profileImageUrl,
        clearImageUrl: profileImageUrl == null,
      );
      
      // Load local profile image path if it exists
      await UserProvider.loadLocalProfileImage(authState.uid);
    } else {
      // Fallback
      UserProvider.updateProfile(
        name: authState.displayName ?? '',
        email: authState.email,
        clearLocalImage: true,
        clearImageUrl: true,
      );
    }
    return userData;
  } catch (e) {
    throw Exception('Error fetching user profile: ${e.toString()}');
  }
});

// Provider untuk fetch latest lab result dari database berdasarkan session saat ini
final latestLabResultProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  // Watch auth state changes so we fetch fresh database profile when session changes
  final authState = ref.watch(authStateChangesProvider).value;
  if (authState == null) return null;

  try {
    final authService = ref.watch(authServiceProvider);
    return await authService.fetchLatestLabData();
  } catch (e) {
    throw Exception('Error fetching latest lab result: ${e.toString()}');
  }
});

// Provider untuk mendapatkan assessment/analisis terbaru
final latestAnalysisProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authState = ref.watch(authStateChangesProvider).value;
  if (authState == null) {
    DashboardContent.clearAnalysisData();
    return null;
  }

  try {
    final authService = ref.watch(authServiceProvider);
    
    // Only fetch AI Result since analysis_results is the single source of truth (just like website)
    final aiResultData = await authService.fetchAiResult();
    
    if (aiResultData == null) {
      DashboardContent.clearAnalysisData();
      return null;
    }
    
    final String mode = aiResultData['mode'] ?? 'kuesioner';
    final String baseType = mode == 'clinical' ? 'lab' : 'kuesioner';
    
    Map<String, dynamic>? baseData;
    if (baseType == 'lab') {
      baseData = aiResultData['clinicalParams'] ?? aiResultData['data'];
    } else {
      baseData = aiResultData['answers'] ?? aiResultData['data'];
    }
    
    if (baseData == null) {
      // Fallback
      baseData = {};
    }

    return {
      'type': baseType, 
      'data': baseData,
      'ai_result': aiResultData,
    };
  } catch (e) {
    debugPrint("Error fetching latest analysis: $e");
    DashboardContent.clearAnalysisData();
    return null;
  }
});
