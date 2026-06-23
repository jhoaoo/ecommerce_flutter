enum AppRole { customer, seller, admin }

extension AppRoleExtension on AppRole {
  String get key {
    switch (this) {
      case AppRole.customer:
        return 'customer';
      case AppRole.seller:
        return 'seller';
      case AppRole.admin:
        return 'admin';
    }
  }

  String get label {
    switch (this) {
      case AppRole.customer:
        return 'Usuario';
      case AppRole.seller:
        return 'Vendedor';
      case AppRole.admin:
        return 'Admin';
    }
  }

  bool get canManageProducts => this == AppRole.seller || this == AppRole.admin;
  bool get canManageUsers => this == AppRole.admin;
  bool get canManageCategories => this == AppRole.admin;
}

AppRole appRoleFromKey(String? value) {
  switch ((value ?? '').toLowerCase()) {
    case 'seller':
    case 'vendedor':
      return AppRole.seller;
    case 'admin':
    case 'administrator':
      return AppRole.admin;
    default:
      return AppRole.customer;
  }
}
