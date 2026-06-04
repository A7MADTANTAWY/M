class Endpoints {
  Endpoints._();

  // ── Auth ──
  static const String login = 'auth/login/';
  static const String register = 'auth/register/';
  static const String refreshToken = 'auth/token/refresh/';

  // ── Profile ──
  static const String userMe = 'users/me/';

  // ── Categories ──
  static const String categories = 'categories/';

  // ── Workers ──
  static const String workers = 'workers/';
  static const String workersCreate = 'workers/create/';
  static const String workersMe = 'workers/me/';
  static String workerById(int id) => 'workers/$id/';
  static const String workerMyRatings = 'workers/my-ratings/';
  static String workerRatings(int id) => 'workers/$id/ratings/';

  // ── Orders ──
  static const String orders = 'orders/';
  static String orderById(int id) => 'orders/$id/';
  static String orderAccept(int id) => 'orders/$id/accept/';
  static String orderReject(int id) => 'orders/$id/reject/';
  static String orderCancel(int id) => 'orders/$id/cancel/';
  static String orderMarkFinished(int id) => 'orders/$id/mark-finished/';
  static String orderConfirmCompletion(int id) => 'orders/$id/confirm-completion/';

  // ── Favorites ──
  static const String favorites = 'favorites/';
  static String favoriteById(int id) => 'favorites/$id/';

  // ── Ratings ──
  static const String ratings = 'ratings/';

  // ── Notifications ──
  static const String notifications = 'notifications/';
  static String notificationRead(int id) => 'notifications/$id/read/';
  static const String notificationsReadAll = 'notifications/read-all/';
}
