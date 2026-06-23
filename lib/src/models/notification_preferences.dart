class NotificationPreferences {
  const NotificationPreferences({
    required this.orderUpdates,
    required this.promotions,
    required this.stockAlerts,
    required this.offerReminders,
  });

  final bool orderUpdates;
  final bool promotions;
  final bool stockAlerts;
  final bool offerReminders;

  factory NotificationPreferences.defaults() => const NotificationPreferences(
        orderUpdates: true,
        promotions: true,
        stockAlerts: true,
        offerReminders: true,
      );

  factory NotificationPreferences.fromMap(Map<String, dynamic> data) {
    return NotificationPreferences(
      orderUpdates: data['orderUpdates'] != false,
      promotions: data['promotions'] != false,
      stockAlerts: data['stockAlerts'] != false,
      offerReminders: data['offerReminders'] != false,
    );
  }

  NotificationPreferences copyWith({
    bool? orderUpdates,
    bool? promotions,
    bool? stockAlerts,
    bool? offerReminders,
  }) {
    return NotificationPreferences(
      orderUpdates: orderUpdates ?? this.orderUpdates,
      promotions: promotions ?? this.promotions,
      stockAlerts: stockAlerts ?? this.stockAlerts,
      offerReminders: offerReminders ?? this.offerReminders,
    );
  }

  Map<String, dynamic> toMap() => {
        'orderUpdates': orderUpdates,
        'promotions': promotions,
        'stockAlerts': stockAlerts,
        'offerReminders': offerReminders,
      };
}
