final RegExp emailValid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

String? isPasswordValid(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter a password";
  }
  if (value.length < 6) {
    return "Password must be longer than 6 characters";
  }
  return null;
}

String? isEmailValid(String? value) {
  if (value == null || value.isEmpty) {
    return "Please enter an email";
  } else if (!emailValid.hasMatch(value)) {
    return "Please enter a valid email";
  }

  return null;
}
