class PaymentMethodProfile {
  const PaymentMethodProfile({
    required this.id,
    required this.type,
    required this.holder,
    required this.last4,
    required this.isDefault,
  });

  final String id;
  final String type;
  final String holder;
  final String last4;
  final bool isDefault;

  PaymentMethodProfile copyWith({
    String? id,
    String? type,
    String? holder,
    String? last4,
    bool? isDefault,
  }) {
    return PaymentMethodProfile(
      id: id ?? this.id,
      type: type ?? this.type,
      holder: holder ?? this.holder,
      last4: last4 ?? this.last4,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  factory PaymentMethodProfile.fromMap(Map<String, dynamic> data) {
    return PaymentMethodProfile(
      id: data['id']?.toString() ?? '',
      type: data['type']?.toString() ?? 'Tarjeta',
      holder: data['holder']?.toString() ?? '',
      last4: data['last4']?.toString() ?? '0000',
      isDefault: data['isDefault'] == true,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'holder': holder,
        'last4': last4,
        'isDefault': isDefault,
      };
}
