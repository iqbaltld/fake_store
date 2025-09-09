# Fake Store - E-commerce Flutter App

A polished e-commerce application built with Flutter that consumes the FakeStore API. This project demonstrates clean architecture, modern UI/UX patterns, and comprehensive feature implementation.

## Features

### Core Features
- **Product Catalog**: Browse products with images, titles, prices, and categories
- **Product Details**: View detailed product information with add-to-cart functionality  
- **Shopping Cart**: Manage cart items with quantity updates, removal, and totals
- **Persistent Cart**: Cart data persists across app sessions using SharedPreferences
- **Category Filtering**: Filter products by categories with smooth animations
- **Search & Navigation**: Intuitive navigation with smooth page transitions

### Advanced Features
- **Theme Switcher**: Toggle between light and dark modes with persistent preference
- **Localization**: Full app localization in English and Arabic (RTL support)
- **Offline Caching**: Smart caching with graceful offline/online transitions
- **Loading States**: Shimmer animations and proper loading indicators
- **Error Handling**: Comprehensive error handling with retry mechanisms
- **Responsive Design**: Adaptive UI using ScreenUtil for different screen sizes

## Architecture

### Clean Architecture Implementation
```
lib/
├── core/                     # Shared utilities and base classes
│   ├── base/                # Base repository implementations  
│   ├── constants/           # API URLs and app constants
│   ├── error/              # Error handling (failures, exceptions)
│   ├── network/            # Network utilities and connectivity
│   ├── theme/              # Theme management and colors
│   └── widgets/            # Reusable UI components
├── features/               # Feature-based modules
│   ├── authentication/     # User authentication (future feature)
│   ├── cart/              # Shopping cart functionality
│   │   ├── data/          # Data sources, repositories, models
│   │   ├── domain/        # Entities, repositories, use cases
│   │   └── presentation/  # UI, cubits, screens, widgets
│   └── product/           # Product catalog and details
│       ├── data/          # API integration and caching
│       ├── domain/        # Business logic and entities
│       └── presentation/  # UI components and state management
└── generated/             # Auto-generated files (localization, DI)
```

### Design Patterns Used
- **Clean Architecture**: Clear separation of concerns across layers
- **Repository Pattern**: Abstract data sources with caching strategies  
- **BLoC/Cubit**: Predictable state management with flutter_bloc
- **Dependency Injection**: Using get_it and injectable for loose coupling
- **Use Cases**: Encapsulated business logic operations
- **Factory Pattern**: For creating different data source implementations

## State Management

### BLoC/Cubit Implementation
- **ProductsCubit**: Manages product listing, categories, and filtering
- **ProductDetailsCubit**: Handles individual product detail loading
- **CartCubit**: Shopping cart state management with persistence
- **ThemeCubit**: Theme switching with SharedPreferences persistence
- **LanguageCubit**: Localization state management

### Caching Strategy
- **Smart Caching**: 1-hour expiration for product lists and categories
- **Fresh-First Product Details**: Always fetch latest data when online
- **Offline Fallback**: Graceful degradation to cached data when offline
- **Network-Aware**: Automatic detection of connectivity status

## Technical Stack

### Dependencies
- **flutter_bloc**: State management and reactive programming
- **dio**: HTTP client with interceptors and error handling
- **get_it + injectable**: Dependency injection and service location
- **shared_preferences**: Local data persistence
- **cached_network_image**: Optimized image caching and loading
- **connectivity_plus**: Network connectivity detection
- **flutter_screenutil**: Responsive design utilities
- **shimmer**: Loading animation effects
- **dartz**: Functional programming (Either type for error handling)

### Development Tools
- **build_runner**: Code generation for DI and JSON serialization
- **flutter_lints**: Code quality and style enforcement
- **bloc_test + mocktail**: Testing utilities for BLoC and mocking
- **intl_utils**: Localization code generation

## API Integration

### FakeStore API Endpoints
- `GET /products` - Product catalog with pagination
- `GET /products/{id}` - Individual product details
- `GET /products/categories` - Available categories
- `GET /products/category/{category}` - Products by category

### Error Handling Strategy
- **Network Errors**: Automatic retry with exponential backoff
- **Server Errors**: User-friendly error messages with retry options
- **Offline Mode**: Seamless fallback to cached data
- **Loading States**: Proper loading indicators and shimmer effects

## UI/UX Design

### Design System
- **Material Design 3**: Modern Material You design principles
- **Consistent Typography**: Poppins font family with proper hierarchy
- **Color System**: Semantic colors with dark theme support
- **Spacing**: 8px grid system using ScreenUtil
- **Animations**: Smooth transitions and micro-interactions

### Responsive Design
- **Adaptive Layouts**: Grid layouts that adjust to screen size
- **Safe Areas**: Proper handling of notches and system UI
- **Accessibility**: Semantic labels and proper focus management
- **RTL Support**: Full right-to-left layout support for Arabic

## 🧪 Testing

### Testing Strategy
- **Unit Tests**: Business logic and use case testing
- **Widget Tests**: UI component testing with proper mocking
- **Cubit Tests**: State management testing with bloc_test
- **Integration Tests**: End-to-end user flow testing

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.32.5+
- Dart SDK 3.5.0+
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd fake_store

# Install dependencies
flutter pub get

# Generate code
flutter packages pub run build_runner build

# Generate localization
flutter packages pub run intl_utils:generate

# Run the app
flutter run
```

### Build for Production
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS  
flutter build ios --release
```

## 🔧 Configuration

### API Configuration
Update API base URL in `lib/core/constants/api_urls.dart`:
```dart
class ApiUrls {
  static const String baseUrl = 'https://fakestoreapi.com';
  // ... other endpoints
}
```

### Localization
Add new translations in:
- `lib/l10n/intl_en.arb` (English)
- `lib/l10n/intl_ar.arb` (Arabic)

Then run: `flutter packages pub run intl_utils:generate`

## 🔍 Architecture Decisions

### Why Clean Architecture?
- **Separation of Concerns**: Each layer has a single responsibility
- **Testability**: Easy to unit test business logic in isolation
- **Maintainability**: Changes in UI don't affect business logic
- **Scalability**: Easy to add new features and data sources

### Why BLoC Pattern?
- **Predictable State**: Clear state transitions and debugging
- **Reactive Programming**: Stream-based approach for real-time updates
- **Testing**: Excellent testing support with bloc_test
- **Platform Agnostic**: Business logic separated from UI

### Caching Strategy Trade-offs
- **Performance vs Freshness**: Balanced approach with configurable expiration
- **Storage vs Network**: Intelligent use of local storage for offline capability
- **Memory vs Disk**: SharedPreferences for persistence, memory for active data

## ⚠️ Known Limitations & Trade-offs

### Current Limitations
1. **Authentication**: Not implemented (FakeStore API limitation)
2. **Real Checkout**: Mock checkout process (API limitation)
3. **Push Notifications**: Not implemented (out of scope)
4. **Social Login**: Not implemented (API limitation)

### Technical Trade-offs
1. **SharedPreferences vs SQLite**: Chose SharedPreferences for simplicity, SQLite would be better for complex data
2. **Client-side cart vs API cart**: Using local cart due to API limitations
3. **Image optimization**: Using cached_network_image instead of custom optimization
4. **Offline-first vs Online-first**: Hybrid approach balancing performance and freshness

### Performance Considerations
- **Image Loading**: Cached network images with placeholder and error states
- **List Performance**: Efficient GridView with proper itemBuilder
- **Memory Management**: Proper disposal of resources and streams
- **Bundle Size**: Optimized with only necessary dependencies

## 🚀 Future Enhancements

### Short-term Improvements
- [ ] Add product search functionality
- [ ] Implement wishlist/favorites feature
- [ ] Add product reviews and ratings
- [ ] Enhanced cart persistence with encryption

### Long-term Features  
- [ ] User authentication and profiles
- [ ] Order history and tracking
- [ ] Payment integration
- [ ] Push notifications
- [ ] Social sharing features
- [ ] Advanced analytics and crash reporting

## 📝 Development Guidelines

### Code Style
- Follow Flutter style guide and linting rules
- Use meaningful variable and function names
- Implement proper error handling in all layers
- Add documentation for complex business logic

### Git Workflow
- Feature branches for new functionality
- Meaningful commit messages following conventional commits
- Code review process before merging
- Proper versioning and changelog maintenance

## 📄 License

This project is created for educational and demonstration purposes.

---

**Built with ❤️ using Flutter**

*This project demonstrates modern Flutter development practices including clean architecture, state management, testing, and comprehensive UI/UX implementation.*