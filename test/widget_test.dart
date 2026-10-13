import 'package:flutter_test/flutter_test.dart';

import 'package:fe_mobile/main.dart';

void main() {
  testWidgets('homepage displays both favorite sections', (tester) async {
    await tester.pumpWidget(const InvoksApp());

    expect(find.text('Top 3 Ruangan Favorit'), findsOneWidget);
    expect(find.text('Top 3 Barang Favorit'), findsOneWidget);
  });

  testWidgets('sidebar opens and closes from outside tap', (tester) async {
    await tester.pumpWidget(const InvoksApp());

    await tester.tap(find.byTooltip('Buka menu'));
    await tester.pumpAndSettle();

    expect(find.text('Keranjang barang'), findsOneWidget);

    await tester.tapAt(const Offset(700, 400));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(780, 30));
    await tester.pump();

    expect(
      find.text('Halaman pencarian akan segera hadir.'),
      findsOneWidget,
    );
  });
}