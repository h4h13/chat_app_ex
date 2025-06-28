import 'package:chat_app_ex/features/login/data/models/country_model.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@injectable
class CountryService {
  static const String _baseUrl = 'https://restcountries.com/v3.1';

  Future<List<Country>> getCountries() async {
    try {
      final http.Response response = await http.get(
        Uri.parse('$_baseUrl/all?fields=name,flags'),
      );

      if (response.statusCode == 200) {
        return Country.parseCountries(response.body);
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }
}
