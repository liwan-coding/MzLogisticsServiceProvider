class AppConfig {
  const AppConfig._();

  static const String _apiBaseUrlFromEnv = String.fromEnvironment('API_BASE_URL');

  /// Local MoveX API. Override with `--dart-define=API_BASE_URL=...`.
  static const String apiBaseUrlDefault = 'http://192.168.100.153:8000/api/v1';

  static String get apiBaseUrl {
    if (_apiBaseUrlFromEnv.isNotEmpty) return _apiBaseUrlFromEnv;
    return apiBaseUrlDefault;
  }

  static const String demoEmail = 'provider@omanhaulers.om';
  static const String demoPassword = 'Password123!';

  /// Temporarily hidden until live tracking is ready to ship.
  static const bool liveTrackingEnabled = false;
  static const String defaultCurrency = 'OMR';
  static const List<String> truckTypes = [
    'flatbed',
    'box',
    'reefer',
    'tanker',
    'lowbed',
    'dump',
    'curtain',
  ];
  static const List<String> tripStatuses = [
    'unassigned',
    'assigned',
    'arrived_at_pickup',
    'loaded',
    'in_transit',
    'arrived',
    'delivered',
    'completed',
  ];
  static const List<String> truckStatuses = [
    'available',
    'assigned',
    'maintenance',
    'inactive',
  ];
  static const List<String> equipmentStatuses = [
    'available',
    'in_use',
    'maintenance',
    'inactive',
  ];
  static const List<String> driverStatuses = [
    'available',
    'on_trip',
    'inactive',
  ];
  static const List<String> paymentMethods = [
    'thawani',
    'cash',
  ];
  static const List<String> paymentStatuses = [
    'pending',
    'processing',
    'completed',
    'failed',
    'refunded',
  ];
  static const List<String> invoiceStatuses = [
    'issued',
    'paid',
    'void',
  ];
  static const List<String> invoiceTypes = [
    'customer',
    'provider',
  ];
  static const List<String> settlementStatuses = [
    'pending',
    'processing',
    'completed',
  ];
  static const List<String> walletTransactionTypes = [
    'job_earning',
    'earning_released',
    'payout_reserved',
    'payout_completed',
    'payout_rejected',
    'adjustment',
  ];
}
