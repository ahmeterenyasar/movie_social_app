class AppConstants {
  AppConstants._();

  /* Padding & Margin */
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  /* Border Radius */
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusCircular = 999.0;

  /* Icon Sizes */
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  /* Movie Card Dimensions */
  static const double movieCardWidth = 140.0;
  static const double movieCardHeight = 210.0;
  static const double movieCardAspectRatio = 2 / 3;

  /* Button Dimensions */
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightLarge = 56.0;

  /* Avatar Sizes */
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 64.0;
  static const double avatarSizeXLarge = 96.0;

  /* Elevation */
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;

  /* Animation Durations */
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  /* API & Image */
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/';
  static const String posterSize = 'w500';
  static const String backdropSize = 'w1280';
  static const String profileSize = 'w185';

  /* Timeouts */
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration shortDelay = Duration(milliseconds: 500);
  static const Duration mediumDelay = Duration(seconds: 1);
  static const Duration longDelay = Duration(seconds: 2);

  /* Limits */
  static const int maxSearchResults = 20;
  static const int moviesPerPage = 20;
  static const int maxFavorites = 1000;

  /* Rating */
  static const double maxRating = 10.0;
  static const int ratingStars = 5;
}
