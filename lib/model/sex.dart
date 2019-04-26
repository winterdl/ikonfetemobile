enum Sex {
  male,
  female,
}

class SexConverter {
  static final List<Sex> sexes = [Sex.male, Sex.female];

  static Sex strToSex(String str) {
    str = str.toLowerCase();
    if (str == "m" || str == "male") {
      return Sex.male;
    } else if (str == "f" || str == "female") {
      return Sex.female;
    } else {
      throw ArgumentError("Invalid sex");
    }
  }

  static String sexToStr(Sex sex) {
    switch (sex) {
      case Sex.male:
        return "male";
      case Sex.female:
        return "female";
    }
    throw ArgumentError("Invalid sex");
  }
}
