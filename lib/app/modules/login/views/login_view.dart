import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code/app/controllers/auth_controller.dart';
import 'package:qr_code/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController emailC =
      TextEditingController(text: 'admin@gmail.com');
  final TextEditingController passC = TextEditingController(text: 'admin123');

  final AuthController authC = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LoginView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextField(
              style: GoogleFonts.outfit(),
              autocorrect: false,
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.outfit(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            const Gap(20),
            Obx(
              () => TextField(
                style: GoogleFonts.outfit(),
                autocorrect: false,
                controller: passC,
                keyboardType: TextInputType.text,
                obscureText: controller.isHidden.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: GoogleFonts.outfit(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.isHidden.toggle();
                    },
                    icon: Icon((controller.isHidden.value)
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ),
            const Gap(25),
            ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  // agar tidak double click
                  // ....

                  if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
                    controller.isLoading(true);

                    Map<String, dynamic> response =
                        await authC.login(emailC.text, passC.text);
                    if (response['error'] == true) {
                      Get.snackbar('Oh Snap!', response['message']);
                    } else {
                      Get.offAllNamed(Routes.HOME);
                    }

                    controller.isLoading(false);
                  } else {
                    Get.snackbar('Oh Snap!', 'Email dan password wajib diisi.');
                  }
                }
              },
              child: Obx(
                () => Text(
                  controller.isLoading.isFalse ? 'Sign In' : 'Loading...',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            )
          ],
        ));
  }
}
