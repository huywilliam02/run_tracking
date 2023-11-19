import 'package:get/get.dart';

import '../modules/change_password/bindings/change_password_binding.dart';
import '../modules/change_password/views/change_password_view.dart';
import '../modules/choose_language/bindings/choose_language_binding.dart';
import '../modules/choose_language/views/choose_language_view.dart';
import '../modules/count_down_timer/bindings/count_down_timer_binding.dart';
import '../modules/count_down_timer/views/count_down_timer_view.dart';
import '../modules/edit_health/bindings/edit_health_binding.dart';
import '../modules/edit_health/views/edit_health_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/forget_password/bindings/forget_password_binding.dart';
import '../modules/forget_password/views/forget_password_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_choose_page.dart';
import '../modules/login/views/splash.dart';
import '../modules/setting_basic/bindings/setting_basic_binding.dart';
import '../modules/setting_basic/views/setting_basic_view.dart';
import '../modules/setting_language/bindings/setting_language_binding.dart';
import '../modules/setting_language/views/setting_language_view.dart';
import '../modules/sign-up/bindings/sign_up_binding.dart';
import '../modules/sign-up/views/sign_up_view.dart';
import '../modules/start-app/bindings/start_app_binding.dart';
import '../modules/start-app/views/start_app_view.dart';
import '../modules/tab_view/bindings/tab_binding.dart';
import '../modules/tab_view/views/tab_view.dart';
import '../modules/tracking-drink_water/bindings/tracking_drink_water_binding.dart';
import '../modules/tracking-drink_water/views/views.dart';
import '../modules/tracking_detail/bindings/tracking_detail_binding.dart';
import '../modules/tracking_detail/views/tracking_detail_view.dart';
import '../modules/tracking_map_v2/bindings/tracking_map_v2_binding.dart';
import '../modules/tracking_map_v2/views/tracking_map_v2_view.dart';
import '../modules/tracking_result/bindings/tracking_result_binding.dart';
import '../modules/tracking_result/views/tracking_result_view.dart';
import '../modules/tracking_step/bindings/tracking_step_binding.dart';
import '../modules/tracking_step/views/tracking_step_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.START_APP;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => MainTabView(),
      binding: MainTabBinding(),
    ),
    GetPage(
      name: _Paths.COUNT_DOWN_TIMER,
      page: () => CountDownTimerView(),
      binding: CountDownTimerBinding(),
    ),
    GetPage(
      name: _Paths.TRACKING_RESULT,
      page: () => TrackingResultView(),
      binding: TrackingResultBinding(),
    ),
    GetPage(
      name: _Paths.TRACKING_DETAIL,
      page: () => TrackingDetailView(),
      binding: TrackingDetailBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => SplashStart(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.START_APP,
      page: () => StartAppView(),
      binding: StartAppBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_BASIC_INFO,
      page: () => SettingBasicInfoView(),
      binding: SettingBasicInfoBinding(),
    ),
    GetPage(
      name: _Paths.TRACKING_DRINK_WATER,
      page: () => TrackingDrinkWaterView(),
      binding: TrackingDrinkWaterBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.TRACKING_MAP_V2,
      page: () => const TrackingMapV2View(),
      binding: TrackingMapV2Binding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_LANGUAGE,
      page: () => ChooseLanguageView(),
      binding: ChooseLanguageBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_LANGUAGE,
      page: () => SettingLanguageView(),
      binding: SettingLanguageBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_HEALTH,
      page: () => EditHealthView(),
      binding: EditHealthBinding(),
    ),
    GetPage(
      name: _Paths.TRACKING_STEP,
      page: () =>  TrackingStepView(),
      binding: TrackingStepBinding(),
    ),
  ];
}
