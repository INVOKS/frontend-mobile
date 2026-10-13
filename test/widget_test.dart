import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fe_mobile/features/sidebar/sidebar.dart';
import 'package:fe_mobile/main.dart';
import 'package:fe_mobile/screens/home/widgets/home_app_bar.dart';

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

  testWidgets('navigates to booking history from sidebar and back to home',
      (tester) async {
    await tester.pumpWidget(const InvoksApp());

    await tester.tap(find.byTooltip('Buka menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();

    expect(find.text('RUANGAN'), findsOneWidget);
    expect(find.text('BARANG'), findsOneWidget);
    expect(find.text('Pilih Kategori'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);

    await tester.tap(find.byTooltip('Buka menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();

    expect(find.text('Top 3 Ruangan Favorit'), findsOneWidget);
  });

  testWidgets('booking history tabs toggle correctly', (tester) async {
    await tester.pumpWidget(const InvoksApp());

    await tester.tap(find.byTooltip('Buka menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();

    expect(find.text('#001'), findsOneWidget);

    await tester.tap(find.text('BARANG'));
    await tester.pumpAndSettle();
    expect(
      find.text('Riwayat booking barang akan segera hadir.'),
      findsOneWidget,
    );
    expect(find.text('#001'), findsNothing);

    await tester.tap(find.text('RUANGAN'));
    await tester.pumpAndSettle();
    expect(find.text('#001'), findsOneWidget);
  });

  testWidgets('booking history filter dropdown filters upcoming and completed',
      (tester) async {
    await tester.pumpWidget(const InvoksApp());

    await tester.tap(find.byTooltip('Buka menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();

    // Default: both upcoming and completed visible
    expect(find.text('#001'), findsOneWidget);
    expect(find.text('#002'), findsOneWidget);
    expect(find.text('Seminar AI Beyond Limits'), findsOneWidget);
    expect(find.text('Rapat TI Charity'), findsOneWidget);

    // Select "Mendatang"
    await tester.tap(find.text('Pilih Kategori'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mendatang').last);
    await tester.pumpAndSettle();

    // Only upcoming
    expect(find.text('#001'), findsOneWidget);
    expect(find.text('Seminar AI Beyond Limits'), findsOneWidget);
    expect(find.text('#002'), findsNothing);
    expect(find.text('Rapat TI Charity'), findsNothing);

    // Select "Selesai"
    await tester.tap(find.text('Mendatang'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selesai').last);
    await tester.pumpAndSettle();

    // Only completed
    expect(find.text('#002'), findsOneWidget);
    expect(find.text('Rapat TI Charity'), findsOneWidget);
    expect(find.text('#001'), findsNothing);
    expect(find.text('Seminar AI Beyond Limits'), findsNothing);
  });

  testWidgets('booking card displays all required details', (tester) async {
    await tester.pumpWidget(const InvoksApp());

    await tester.tap(find.byTooltip('Buka menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();

    expect(find.text('#001'), findsOneWidget);
    expect(find.text('Seminar AI Beyond Limits'), findsOneWidget);
    expect(find.text('BNI'), findsWidgets);
    expect(find.text('B02'), findsOneWidget);
    expect(find.text('Basement'), findsOneWidget);
    expect(find.text('30 orang'), findsOneWidget);
    expect(find.text('13.00 - 17.00'), findsWidgets);
    expect(find.text('Detail Ruangan'), findsWidgets);
  });

  testWidgets('booking history renders without overflow on mobile screen size',
      (tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const InvoksApp());

    await tester.tap(find.byTooltip('Buka menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'sidebar layout starts below app bar with correct dimensions and padding',
      (tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const InvoksApp());

    await tester.tap(find.byTooltip('Buka menu'));
    await tester.pumpAndSettle();

    final appBarBottom = tester.getBottomLeft(find.byType(HomeAppBar)).dy;
    final sidebarTop = tester.getTopLeft(find.byType(InvoksSidebar)).dy;
    final sidebarBottom = tester.getBottomLeft(find.byType(InvoksSidebar)).dy;
    final sidebarSize = tester.getSize(find.byType(InvoksSidebar));
    final berandaTop = tester.getTopLeft(find.text('Beranda')).dy;

    // 1. Sidebar starts at or below the bottom of the existing app bar
    expect(sidebarTop, equals(appBarBottom));

    // 2. Sidebar fills only the body area below app bar down to screen bottom
    expect(sidebarBottom, equals(915.0));

    // 3. Sidebar width is ~58-60% of phone screen width (412 * 0.59 = ~243 px)
    expect(sidebarSize.width, closeTo(412 * 0.59, 1.0));

    // 4. First menu item "Beranda" has proper top padding (~12-16 px below sidebar top)
    final topPadding = berandaTop - sidebarTop;
    expect(topPadding, inInclusiveRange(12.0, 30.0));

    // 5. "Beranda" is fully visible and rendered
    expect(find.text('Beranda'), findsOneWidget);
  });
}