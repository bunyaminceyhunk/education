import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  late final AnimationController _emailFocusAnimController;
  late final AnimationController _passwordFocusAnimController;

  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailFocusAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _passwordFocusAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        _emailFocusAnimController.forward();
      } else {
        _emailFocusAnimController.reverse();
      }
      setState(() {});
    });

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        _passwordFocusAnimController.forward();
      } else {
        _passwordFocusAnimController.reverse();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailFocusAnimController.dispose();
    _passwordFocusAnimController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      final String message = _mapAuthErrorToTrMessage(e);
      _showSnack(message);
    } catch (_) {
      _showSnack('Bir hata oluştu. Lütfen tekrar deneyin.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleForgotPassword() async {
    final String email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnack('Şifre sıfırlama için e‑posta adresi girin.');
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnack('Şifre sıfırlama e‑postası gönderildi.');
    } on FirebaseAuthException catch (e) {
      _showSnack(_mapAuthErrorToTrMessage(e));
    } catch (_) {
      _showSnack('İşlem gerçekleştirilemedi.');
    }
  }

  String _mapAuthErrorToTrMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Geçersiz e‑posta adresi.';
      case 'user-disabled':
        return 'Bu kullanıcı devre dışı bırakılmış.';
      case 'user-not-found':
        return 'Kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Şifre hatalı.';
      case 'too-many-requests':
        return 'Çok fazla deneme. Lütfen daha sonra tekrar deneyin.';
      case 'network-request-failed':
        return 'Ağ hatası. İnternet bağlantınızı kontrol edin.';
      default:
        return 'Giriş yapılamadı: ${e.message ?? e.code}';
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool get _canSubmit {
    return _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        !_isLoading;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Color background = const Color(0xFF0E0E0E);
    final Color inputFill = const Color(0xFF1C1C1E);
    final Color inputBorder = const Color(0xFF2C2C2E);
    final Color hint = const Color(0xFF9E9EA0);
    final Color buttonDisabled = const Color(0xFFBDBDBD);
    final Color green = const Color(0xFF22C55E);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Text(
                'Giriş yapabilmek için lütfen hesap bilgilerinle giriş yap.',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              // Email field with subtle focus animation
              _AnimatedInputWrapper(
                controller: _emailFocusAnimController,
                focused: _emailFocusNode.hasFocus,
                fillColor: inputFill,
                borderColor: inputBorder,
                child: TextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'E-posta veya kullanıcı adını gir',
                    hintStyle: TextStyle(color: hint),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                ),
              ),
              const SizedBox(height: 16),

              // Password field with eye toggle and animation
              _AnimatedInputWrapper(
                controller: _passwordFocusAnimController,
                focused: _passwordFocusNode.hasFocus,
                fillColor: inputFill,
                borderColor: inputBorder,
                child: TextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  obscureText: _isObscure,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Şifre',
                    hintStyle: TextStyle(color: hint),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    suffixIcon: AnimatedScale(
                      scale: _isObscure ? 1.0 : 1.1,
                      duration: const Duration(milliseconds: 180),
                      child: IconButton(
                        onPressed: () => setState(() {
                          _isObscure = !_isObscure;
                        }),
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _canSubmit ? _handleLogin() : null,
                ),
              ),

              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _handleForgotPassword,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: Text(
                    'Şifremi unuttum',
                    style: TextStyle(
                      color: green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: _canSubmit ? _handleLogin : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _canSubmit ? Colors.white : buttonDisabled,
                    disabledBackgroundColor: buttonDisabled,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.6,
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        )
                      : const Text('Giriş Yap'),
                ),
              ),

              const SizedBox(height: 24),

              // Note: Google and Apple buttons are part of the sample UI,
              // but only email+password authentication is implemented as requested.
              // You can connect these later if needed.
              _ThirdPartyButton(
                label: 'Google ile giriş yap',
                leading: _GoogleGlyph(),
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              _ThirdPartyButton(
                label: 'Apple ile giriş yap',
                leading: const Icon(Icons.apple, size: 28, color: Colors.white),
                onPressed: () {},
              ),

              const SizedBox(height: 24),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Bir hesabın yok mu? ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/register'),
                      child: const Text(
                        'Kayıt Ol',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedInputWrapper extends StatelessWidget {
  const _AnimatedInputWrapper({
    required this.controller,
    required this.focused,
    required this.child,
    required this.fillColor,
    required this.borderColor,
  });

  final AnimationController controller;
  final bool focused;
  final Widget child;
  final Color fillColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final Animation<double> elevation = Tween<double>(begin: 0, end: 6)
        .chain(CurveTween(curve: Curves.easeOutCubic))
        .animate(controller);
    final Animation<Color?> border = ColorTween(
      begin: borderColor,
      end: Colors.white24,
    ).animate(controller);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Material(
          color: fillColor,
          elevation: elevation.value,
          shadowColor: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: focused ? (border.value ?? borderColor) : borderColor, width: 1),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class _ThirdPartyButton extends StatelessWidget {
  const _ThirdPartyButton({
    required this.label,
    required this.leading,
    required this.onPressed,
  });

  final String label;
  final Widget leading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.06),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            leading,
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleGlyph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simple stylized G to resemble Google mark without external assets
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: const Text(
        'G',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}