import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/item_detail/bindings/item_detail_binding.dart';
import '../modules/item_detail/views/item_detail_view.dart';
import '../modules/items/bindings/items_binding.dart';
import '../modules/items/views/items_view.dart';
import '../modules/loan_form/bindings/loan_form_binding.dart';
import '../modules/loan_form/views/loan_form_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/my_loans/bindings/my_loans_binding.dart';
import '../modules/my_loans/views/my_loans_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/return_form/bindings/return_form_binding.dart';
import '../modules/return_form/views/return_form_view.dart';
import '../modules/scan_qr/bindings/scan_qr_binding.dart';
import '../modules/scan_qr/views/camera_photo_view.dart';
import '../modules/scan_qr/views/scan_qr_view.dart';
import '../modules/warehouse_map/bindings/warehouse_map_binding.dart';
import '../modules/warehouse_map/views/warehouse_map_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.HOME,
          page: () => const HomeView(),
          binding: HomeBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ITEMS,
      page: () => const ItemsView(),
      binding: ItemsBinding(),
    ),
    GetPage(
      name: _Paths.ITEM_DETAIL,
      page: () => const ItemDetailView(),
      binding: ItemDetailBinding(),
    ),
    GetPage(
      name: _Paths.SCAN_QR,
      page: () => const ScanQrView(),
      binding: ScanQrBinding(),
    ),
    GetPage(
      name: _Paths.LOAN_FORM,
      page: () => const LoanFormView(),
      binding: LoanFormBinding(),
    ),
    GetPage(
      name: _Paths.MY_LOANS,
      page: () => const MyLoansView(),
      binding: MyLoansBinding(),
    ),
    GetPage(
      name: _Paths.RETURN_FORM,
      page: () => const ReturnFormView(),
      binding: ReturnFormBinding(),
    ),
    GetPage(
      name: _Paths.WAREHOUSE_MAP,
      page: () => const WarehouseMapView(),
      binding: WarehouseMapBinding(),
    ),
    GetPage(
      name: _Paths.CAMERA,
      page: () => const CameraPhotoView(),
      binding: ScanQrBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
