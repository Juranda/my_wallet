import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test/test.dart';

void main() {
  test('env should run correcly', () async {
    await dotenv.load(fileName: 'assets/env/.dev.env');

    print(dotenv.get('ANNON_KEY'));
    print(dotenv.get('SUPABASE_URL'));
  });
}
