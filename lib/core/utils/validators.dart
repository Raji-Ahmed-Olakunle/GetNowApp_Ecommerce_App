class Validator {
  String? isEmail(String value) {
    final RegExp isvalidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value == null) {
      return 'Enter a Email';
    } else if (!isvalidEmail.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }
}

String? validateTitle(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the Product Name';
  }
  return null;
}

String? validatePrice(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a price';
  } else if (double.tryParse(value) == null) {
    return 'Enter a valid price';
  } else if (double.tryParse(value)! <= 0) {
    return 'Price cannot be less than zero, enter a valid price';
  }
  return null;
}

String? validateQuantity(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter quantity';
  } else if (int.tryParse(value) == null) {
    return 'Enter a valid quantity';
  } else if (int.tryParse(value)! < 0) {
    return 'Quantity cannot be negative';
  }
  return null;
}

String? validateDescription(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a description';
  }
  return null;
}

String? validateImageUrl(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an image URL';
  }
  // Optionally add more checks for URL format
  return null;
}

String? validateCategories(List? value) {
  if (value == null || value.isEmpty) {
    return 'Select categories';
  }
  return null;
}
