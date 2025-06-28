import 'dart:convert';

class Country {
  final String name;
  final String flagUrl;

  Country({required this.name, required this.flagUrl});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(name: json['name']['common'], flagUrl: json['flags']['png']);
  }

  static List<Country> parseCountries(String responseBody) {
    final List<dynamic> parsed = jsonDecode(responseBody);
    return parsed.map<Country>((json) => Country.fromJson(json)).toList();
  }
}
