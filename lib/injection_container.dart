import 'dart:async';

// External packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core imports
import 'package:fake_store/core/constants/api_urls.dart';
import 'package:fake_store/core/network/custom_interceptor.dart';
import 'package:fake_store/core/services/navigation_service/navigation_service.dart';

// Generated code for dependency injection
import 'injection_container.config.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Configures and initializes all generated dependencies using injectable.
/// This should be called before any other dependency registration.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();

/// Sets up and configures all dependencies for the application.
/// This function should be called during app initialization.
Future<void> setupDependencyInjection() async {
  // 1. Register core services first
  await _registerCoreServices();

  // 2. Register navigation dependencies
  _registerNavigationDependencies();

  // 3. Register network-related dependencies
  _registerNetworkDependencies();

  // 4. Initialize generated dependencies last
  configureDependencies();

  // 5. Register any additional dependencies that need manual setup
  _registerAdditionalDependencies();
}

/// Registers core services like SharedPreferences and Connectivity
Future<void> _registerCoreServices() async {
  // Initialize and register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Register Connectivity for network status
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
}

/// Registers network-related dependencies including Dio and interceptors
void _registerNetworkDependencies() {
  // Configure Dio with base options
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Register Dio as a singleton
  getIt.registerLazySingleton<Dio>(() => dio);

  // Register and configure interceptors
  final customInterceptor = CustomInterceptor(
    getIt<SharedPreferences>(),
    getIt<NavigationService>(),
  );

  getIt.registerLazySingleton<CustomInterceptor>(() => customInterceptor);

  // Add interceptors to Dio instance
  dio.interceptors.addAll([
    customInterceptor,
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false, // Headers handled by custom interceptor
      responseHeader: false,
      logPrint: (obj) => debugPrint('API: $obj'), // Custom log format
    ),
  ]);
}

/// Registers navigation-related dependencies
void _registerNavigationDependencies() {
  // Register navigation key
  getIt.registerLazySingleton<GlobalKey<NavigatorState>>(
    () => GlobalKey<NavigatorState>(),
  );

  // Register navigation service with navigatorKey parameter
  getIt.registerLazySingleton<NavigationService>(
    () => NavigationService(navigatorKey: getIt<GlobalKey<NavigatorState>>()),
  );
}

/// Registers additional dependencies that need manual setup
void _registerAdditionalDependencies() {
  // Data sources are registered by the injectable generator
  // No need to manually register them here
}