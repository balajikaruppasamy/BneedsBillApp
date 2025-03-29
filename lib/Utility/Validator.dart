class C_Validator {
  static String? validateEmptyText(String? fieldname, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldname is required';
    }
    return null;
  }

  static String? validateusername(String? usernmae) {
    if (usernmae == null || usernmae.isEmpty) {
      return 'usernmae is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
