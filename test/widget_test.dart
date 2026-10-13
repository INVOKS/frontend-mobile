import 'package:flutter_test/flutter_test.dart';

import 'package:fe_mobile/main.dart';

void main() {
  testWidgets('homepage shows both favorite sections', (tester) async {
    await tester.pumpWidget(const InvoksApp());

    expect(find.text('Top 3 Ruangan Favorit'), findsOneWidget);
    expect(find.text('Top 3 Barang Favorit'), findsOneWidget);
  });
}
