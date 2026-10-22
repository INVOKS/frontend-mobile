import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/dummy_data.dart';
import '../auth_service.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback? onRegisterTap;
  final VoidCallback? onLoginSuccess;

  const LoginForm({super.key, this.onRegisterTap, this.onLoginSuccess});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _remember = true;
  bool _isLoading = false;
  String? _errorMessage;

  String? _emailError;
  String? _passwordError;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    bool hasError = false;

    if (email.isEmpty) {
      _emailError = 'Email tidak boleh kosong';
      hasError = true;
    } else if (!email.contains('@')) {
      _emailError = 'Email harus mengandung tanda "@" (contoh: nama@email.com)';
      hasError = true;
    } else if (!_emailRegex.hasMatch(email)) {
      _emailError = 'Format email tidak lengkap (contoh: nama@email.com)';
      hasError = true;
    }

    if (password.isEmpty) {
      _passwordError = 'Kata sandi tidak boleh kosong';
      hasError = true;
    }

    if (hasError) setState(() {});
    return !hasError;
  }

  Future<void> _handleLogin() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.instance.loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      ingatSaya: _remember,
    );

    if (!mounted) return;

    if (result.success && result.user != null) {
      // Perbarui profil pengguna aktif dengan data dari backend
      userProfileNotifier.value = result.user!.toUserProfile();

      if (widget.onLoginSuccess != null) {
        widget.onLoginSuccess!();
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = result.message;
      });
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
          // ── Pesan Error ──────────────────────────────────────────────────
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

          // ── Email ────────────────────────────────────────────────────────
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

          // ── Password ─────────────────────────────────────────────────────
          TextField(
            controller: _passwordController,
            obscureText: _obscure,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            onSubmitted: (_) => _handleLogin(),
            onChanged: (_) {
              if (_passwordError != null) setState(() => _passwordError = null);
              if (_errorMessage != null) setState(() => _errorMessage = null);
            },
            decoration: InputDecoration(
              hintText: 'Masukkan Kata Sandi',
              hintStyle: const TextStyle(color: AppColors.hint),
              errorText: _passwordError,
              border: _buildBorder(Colors.black87),
              enabledBorder: _buildBorder(Colors.black87),
              focusedBorder: _buildBorder(AppColors.primary),
              errorBorder: _buildBorder(Colors.redAccent),
              focusedErrorBorder: _buildBorder(Colors.redAccent),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: _isLoading
                    ? null
                    : () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Ingat saya + Lupa kata sandi ─────────────────────────────────
          Row(
            children: [
              Checkbox(
                value: _remember,
                onChanged: _isLoading
                    ? null
                    : (v) => setState(() => _remember = v ?? false),
              ),
              const Text('Ingat saya', style: TextStyle(fontSize: 13)),
              const Spacer(),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur lupa kata sandi akan segera hadir.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Lupa kata sandi',
                  style: TextStyle(
                    color: AppColors.link,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Tombol Masuk ─────────────────────────────────────────────────
          SizedBox(
            width: 140,
            height: 44,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                disabledForegroundColor: Colors.white,
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
                      'Masuk',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Link ke Daftar ───────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Tidak punya akun? ', style: TextStyle(fontSize: 12)),
              TextButton(
                onPressed: _isLoading ? null : widget.onRegisterTap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Daftar',
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