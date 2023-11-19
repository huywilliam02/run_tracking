import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracker_run/app/modules/login/controllers/login_controller.dart';
import 'package:tracker_run/app/modules/login/views/login_page.dart';
import 'package:tracker_run/app/resources/app_constants.dart';
import 'package:tracker_run/app/resources/reponsive_utils.dart';
import 'package:tracker_run/generated/locales.g.dart';
import '../../../routes/app_pages.dart';

class LoginChoosePage extends StatefulWidget {
  const LoginChoosePage({super.key});

  @override
  State<LoginChoosePage> createState() => _LoginChoosePageState();
}

class _LoginChoosePageState extends State<LoginChoosePage> {
  PageController pageController = PageController(initialPage: 0);
  List images = [
    "assets/images/start.png",
    "assets/icons/image_1.jpg",
    "assets/icons/image_2.jpg"
  ];
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    int count = 0;
    Future.delayed(const Duration(seconds: 0), () {
      showModalBottomSheet(
          barrierColor: Colors.transparent,
          // backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          enableDrag: false,
          context: context,
          builder: (builder) {

            return WillPopScope(
              onWillPop: (() async => false),
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                height: UtilsReponsive.height(context, 380),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Text(
                          LocaleKeys.start_page_text_title.tr,
                          style: const TextStyle(fontSize: 30),
                        )),
                    Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blueAccent.shade700),
                                onPressed: ()async {
                                // await  Get.find<LoginController>().test2(); 
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.facebook),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            LocaleKeys
                                                .start_page_buttons_sign_in_fb
                                                .tr,
                                            style:
                                                TextStyleConstant.whiteBold16,
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                            )),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),
                                  border: Border.all()),
                              margin: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white),
                                onPressed: () {
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.g_mobiledata_sharp,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            LocaleKeys
                                                .start_page_buttons_sign_in_google
                                                .tr,
                                            style:
                                                TextStyleConstant.blackBold16,
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                            )),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(10),
                                  border: Border.all()),
                              margin: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white),
                                onPressed: () {
                                  Get.toNamed(Routes.SIGN_UP);
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            LocaleKeys
                                                .login_page_text_title_signup
                                                .tr,
                                            style:
                                                TextStyleConstant.blackBold16,
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                            )),
                          ],
                        )),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                          height: 2,
                          color: Colors.grey,
                        )),
                        Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                LocaleKeys.start_page_text_already_member.tr,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            )),
                        Expanded(
                            child: Container(
                          height: 2,
                          color: Colors.grey,
                        ))
                      ],
                    )),
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5, top: 15),
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurpleAccent),
                            onPressed: () {
                              Get.to(()=>LoginPage(),
                                  transition: Transition.rightToLeft);
                            },
                            child: Text(
                              LocaleKeys.start_page_buttons_login.tr,
                              style: TextStyleConstant.whiteBold16,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            );
          });
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        count++;
        pageController.animateToPage(
          count % images.length,
          duration: const Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("ddd");
    LoginController controller = Get.find<LoginController>();
    return Scaffold(
      body: SafeArea(
          child: Stack(
        fit: StackFit.expand,
        children: [
          // Image.asset(
          //   "assets/images/start.png",
          //   fit: BoxFit.fitHeight,
          // ),
          // CarouselSlider(

          //   // carouselController: controller.carouselController,
          //   options: CarouselOptions(
          //     clipBehavior: Clip.none,
          //       viewportFraction: 2,
          //       height: MediaQuery.of(context).size.height,
          //       // onPageChanged: (index,
          //       // reason) {
          //       //   controller.indexFilterStatis.value = index;
          //       // },
          //       // enlargeCenterPage: true,
          //       // scrollPhysics: NeverScrollableScrollPhysics(),
          //       autoPlay: true,
          //       // autoPlayCurve: Curves.fastOutSlowIn,
          //       // autoPlayAnimationDuration: Duration(seconds: 1),
          //       // initialPage: 1,
          //       // viewportFraction: 1,
          //       enableInfiniteScroll: true),
          //   items: [
          //     "assets/images/start.png",
          //     "assets/icons/image_1.jpg",
          //     "assets/icons/image_2.jpg"
          //   ].map((i) {
          //     return Builder(
          //       builder: (BuildContext context) {
          //         return Image.asset(
          //           i,
          //           fit: BoxFit.fitHeight,
          //         );
          //       },
          //     );
          //   }).toList(),
          // ),
          PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            itemBuilder: (context, index) {
              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage(
                //   images[index],
                // )
                // )),
                child: Image.asset(
                  images[index % images.length],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.login_page_text_title.tr,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 70,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Believe it - Achieve it",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ],
      )),
   
    );
  }
}
