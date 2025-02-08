bool validLicensePlate(String str) {
  // Regular expression for validating license plates
  var regExp = RegExp(r'([A-Z,a-z]{3}[0-9]{2}[A-Z,a-z,0-9]{1})');
  return regExp.hasMatch(str);
}

String? licensePlateValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a license plate';
  } else if (!validLicensePlate(value)) {
    return '''
Invalid format!\n
License plate must consist of 3 letters\n
followed by 2 digits and finally a letter or a digit.\n
Example: ABC12D''';
  }
  return null;
}

bool isValidLuhn(String ssn) {
  if (ssn.length != 12) return false;
  int sum = 0;

  //Skip first two digits in ssn
  for (int i = 2; i < ssn.length - 1; i++) {
    int digit = int.parse(ssn[i]);

    //Multiply first digit with 2, second with 1, third with 2...
    int multiplier = (ssn.length - 2 - i) % 2 == 0 ? 2 : 1;
    digit *= multiplier;

    if (digit > 9) {
      //If digit > 9, e.g. 14 add them 1 + 4
      sum += (digit ~/ 10) + (digit % 10);
    } else {
      //else add them to sum
      sum += digit;
    }
  }
  int checkDigit = int.parse(ssn[ssn.length - 1]);
  return (sum + checkDigit) % 10 == 0;
}
