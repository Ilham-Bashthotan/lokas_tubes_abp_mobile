import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final obscure = true.obs;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 56),

              // Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LOK',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    'AS',
                    style: TextStyle(
                      color: cs.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'ASSET SECURITY INFRASTRUCTURE',
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.6),
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 48),

              // Title
              Text('System Access', style: AppTextStyles.headline.copyWith(color: cs.onSurface)),
              const SizedBox(height: 6),
              Text(
                'Initialize authentication sequence',
                style: AppTextStyles.body.copyWith(color: cs.onSurface.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 40),

              // Form Card
              Container(
                decoration: AppDecoration.card.copyWith(
                  color: cs.surfaceContainerHighest,
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email
                    Text(
                      'Email',
                      style: AppTextStyles.label.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'staff@inventorytrack.id',
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          size: 18,
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    Text(
                      'Password',
                      style: AppTextStyles.label.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Obx(
                      () => TextFormField(
                        controller: passCtrl,
                        obscureText: obscure.value,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: Icon(
                            Icons.lock_rounded,
                            size: 18,
                            color: cs.onSurface.withValues(alpha: 0.5),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure.value
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              size: 18,
                              color: cs.onSurface.withValues(alpha: 0.5),
                            ),
                            onPressed: () => obscure.toggle(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Button
                    Obx(
                      () => Container(
                        decoration: AppDecoration.primaryCard,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.login(
                                  email: emailCtrl.text.trim(),
                                  password: passCtrl.text,
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'AUTHORIZE ACCESS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.login_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Footer
              Text('Akun didaftarkan oleh Admin', style: AppTextStyles.caption),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
