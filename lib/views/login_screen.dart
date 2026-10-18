import 'package:flutter/material.dart';

import '../app/routes.dart';
import '../app/theme.dart';
import '../services/local_storage_service.dart';

// Giriş ekranı: ad ve soyad alınır, cihazda saklanır. Şifre yoktur.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form'daki tüm alanları birlikte doğrulamak için
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  // Kayıt sürerken buton kilitlenir; çift basışta iki ana ekran açılmaz.
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isSaving) return;
    // Boş ya da yalnızca boşluktan oluşan alan varsa hata metni gösterilir.
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    // Kayıt başarısız olsa da giriş devam eder (hata serviste konsola yazılır).
    await LocalStorageService().saveUser(
      _nameController.text.trim(),
      _surnameController.text.trim(),
    );

    // await sırasında ekran kapanmış olabilir.
    if (!mounted) return;
    // Login yığından çıkarılır; geri tuşu login'e döndürmez.
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  // Alan boşsa (boşluklar sayılmaz) verilen hata metnini döner.
  String? Function(String?) _requiredValidator(String message) {
    return (value) => (value ?? '').trim().isEmpty ? message : null;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          // Klavye açılınca içerik taşmaz, kaydırılabilir.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome Back', style: textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Please login to your account',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: _requiredValidator('Please enter your name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _surnameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: 'Surname',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: _requiredValidator('Please enter your surname'),
                    // Klavyedeki "done" tuşu da giriş yapar.
                    onFieldSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 24),
                  // Siyah, tam genişlikte buton (CheckoutButton ile aynı görünüm)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.surface,
                        textStyle: textTheme.titleMedium,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _isSaving ? null : _login,
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
