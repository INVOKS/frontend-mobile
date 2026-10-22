import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../auth_service.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback? onLoginTap;
  final VoidCallback? onRegisterSuccess;

  const RegisterForm({super.key, this.onLoginTap, this.onRegisterSuccess});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Per-field error state
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _specialCharRegex = RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>/?]');

  bool _validateInputs() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmError = null;
    });

    bool hasError = false;

    if (name.length < 3) {
      _nameError = 'Nama lengkap minimal 3 karakter';
      hasError = true;
    }

    if (email.isEmpty || !_emailRegex.hasMatch(email)) {
      _emailError = 'Format email tidak valid (contoh: nama@email.com)';
      hasError = true;
    }

    if (password.length < 8) {
      _passwordError = 'Password minimal 8 karakter';
      hasError = true;
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      _passwordError = 'Password harus memiliki setidaknya satu huruf kapital';
      hasError = true;
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      _passwordError = 'Password harus memiliki setidaknya satu huruf kecil';
      hasError = true;
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      _passwordError = 'Password harus memiliki setidaknya satu angka';
      hasError = true;
    } else if (!_specialCharRegex.hasMatch(password)) {
      _passwordError = 'Password harus memiliki setidaknya satu karakter khusus';
      hasError = true;
    }

    if (confirm != password) {
      _confirmError = 'Konfirmasi password tidak cocok';
      hasError = true;
    }

    if (hasError) setState(() {});
    return !hasError;
  }

  Future<void> _handleRegister() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.instance.register(
      namaLengkap: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      konfirmasiPassword: _confirmPasswordController.text,
    );

    if (!mounted) return;

    if (result.success) {
      if (widget.onRegisterSuccess != null) {
        widget.onRegisterSuccess!();
      }
    } else {
      if (result.errors != null && result.errors!.isNotEmpty) {
        setState(() {
          _nameError = result.errors!['namaLengkap'];
          _emailError = result.errors!['email'];
          _passwordError = result.errors!['password'];
          _confirmError = result.errors!['konfirmasiPassword'];
          _errorMessage = null;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result.message;
          _isLoading = false;
        });
      }
    }
  }

  OutlineInputBorder _buildBorder(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // ── Pesan Error Global ────────────────────────────────────────────
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Email ─────────────────────────────────────────────────────────
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            onChanged: (_) {
              if (_emailError != null) setState(() => _emailError = null);
              if (_errorMessage != null) setState(() => _errorMessage = null);
            },
            decoration: InputDecoration(
              hintText: 'Masukkan Email',
              hintStyle: const TextStyle(color: AppColors.hint),
              errorText: _emailError,
              errorMaxLines: 2,
              border: _buildBorder(Colors.black87),
              enabledBorder: _buildBorder(Colors.black87),
              focusedBorder: _buildBorder(AppColors.primary),
              errorBorder: _buildBorder(Colors.redAccent),
              focusedErrorBorder: _buildBorder(Colors.redAccent),
            ),
          ),
          const SizedBox(height: 16),

          // ── Nama Lengkap ──────────────────────────────────────────────────
          TextField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            onChanged: (_) {
              if (_nameError != null) setState(() => _nameError = null);
            },
            decoration: InputDecoration(
              hintText: 'Masukkan Nama Lengkap',
              hintStyle: const TextStyle(color: AppColors.hint),
              errorText: _nameError,
              border: _buildBorder(Colors.black87),
              enabledBorder: _buildBorder(Colors.black87),
              focusedBorder: _buildBorder(AppColors.primary),
              errorBorder: _buildBorder(Colors.redAccent),
              focusedErrorBorder: _buildBorder(Colors.redAccent),
            ),
          ),
          const SizedBox(height: 16),

          // ── Kata Sandi ────────────────────────────────────────────────────
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            onChanged: (_) {
              if (_passwordError != null) setState(() => _passwordError = null);
            },
            decoration: InputDecoration(
              hintText: 'Masukkan Kata Sandi',
              hintStyle: const TextStyle(color: AppColors.hint),
              errorText: _passwordError,
              errorMaxLines: 2,
              border: _buildBorder(Colors.black87),
              enabledBorder: _buildBorder(Colors.black87),
              focusedBorder: _buildBorder(AppColors.primary),
              errorBorder: _buildBorder(Colors.redAccent),
              focusedErrorBorder: _buildBorder(Colors.redAccent),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: _isLoading
                    ? null
                    : () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Verifikasi Kata Sandi ─────────────────────────────────────────
          TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            onSubmitted: (_) => _handleRegister(),
            onChanged: (_) {
              if (_confirmError != null) setState(() => _confirmError = null);
            },
            decoration: InputDecoration(
              hintText: 'Verifikasi Kata Sandi',
              hintStyle: const TextStyle(color: AppColors.hint),
              errorText: _confirmError,
              border: _buildBorder(Colors.black87),
              enabledBorder: _buildBorder(Colors.black87),
              focusedBorder: _buildBorder(AppColors.primary),
              errorBorder: _buildBorder(Colors.redAccent),
              focusedErrorBorder: _buildBorder(Colors.redAccent),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: _isLoading
                    ? null
                    : () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Tombol Daftar ─────────────────────────────────────────────────
          SizedBox(
            width: 140,
            height: 44,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Daftar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Link ke Login ─────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sudah punya akun? ', style: TextStyle(fontSize: 12)),
              TextButton(
                onPressed: _isLoading ? null : widget.onLoginTap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Masuk',
                  style: TextStyle(
                    color: AppColors.link,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
