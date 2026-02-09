import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ortho_waiting_list/functions/shell_function.dart';
import 'package:ortho_waiting_list/providers/px_auth.dart';
import 'package:ortho_waiting_list/router/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  final _emailFieldKey = GlobalKey<FormFieldState>();

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF21899C),
      body: SafeArea(
        child: Column(
          children: [
            //to give space from top
            const Expanded(
              flex: 1,
              child: Center(),
            ),

            //page content here
            Expanded(
              flex: 9,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //header text
                        Text(
                          'قسم جراحة العظام',
                          style: GoogleFonts.inter(
                            fontSize: 24.0,
                            color: const Color(0xFF15224F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          'مجمع الشرطة الطبي بالرحاب',
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: const Color(0xFF969AA8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),

                        //logo section
                        logo(size.height / 8, size.height / 8),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        richText(24),
                        SizedBox(
                          height: size.height * 0.05,
                        ),

                        //email & password section
                        Container(
                          alignment: Alignment.center,
                          height: size.height / 11,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              width: 1.0,
                              color: const Color(0xFFEFEFEF),
                            ),
                          ),
                          child: TextFormField(
                            key: _emailFieldKey,
                            controller: _emailController,
                            style: GoogleFonts.inter(
                              fontSize: 16.0,
                              color: const Color(0xFF15224F),
                            ),
                            maxLines: 1,
                            cursorColor: const Color(0xFF15224F),
                            decoration: InputDecoration(
                              labelText: 'البريد الالكتروني',
                              labelStyle: GoogleFonts.inter(
                                fontSize: 12.0,
                                color: const Color(0xFF969AA8),
                              ),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'برجاء ادخال البريد الالكتروني';
                              } else if (!EmailValidator.validate(value)) {
                                return 'برجاء ادخال بريد الكتروني صحيح';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: size.height / 11,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              width: 1.0,
                              color: const Color(0xFFEFEFEF),
                            ),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            style: GoogleFonts.inter(
                              fontSize: 16.0,
                              color: const Color(0xFF15224F),
                            ),
                            maxLines: 1,
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            cursorColor: const Color(0xFF15224F),
                            decoration: InputDecoration(
                              labelText: 'كلمة السر',
                              labelStyle: GoogleFonts.inter(
                                fontSize: 12.0,
                                color: const Color(0xFF969AA8),
                              ),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'برجاء ادخال كلمة السر';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 20.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color(0xFF21899C),
                                ),
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = !_rememberMe;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'تذكرني',
                                style: GoogleFonts.inter(
                                  fontSize: 15.0,
                                  color: const Color(0xFF0C0D34),
                                ),
                              ),
                              const Spacer(),
                              Text.rich(
                                TextSpan(
                                  text: 'نسيان كلمة السر',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      if (_emailFieldKey.currentState!
                                          .validate()) {
                                        await context
                                            .read<PxAuth>()
                                            .forgotPassword(
                                                _emailController.text);
                                      }
                                    },
                                ),
                                style: GoogleFonts.inter(
                                  fontSize: 13.0,
                                  color: const Color(0xFF21899C),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        //sign in button
                        Consumer<PxAuth>(
                          builder: (context, auth, _) {
                            return InkWell(
                              onTap: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                await shellFunction(context,
                                    toExecute: () async {
                                  await auth.loginWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text,
                                    _rememberMe,
                                  );
                                  if (context.mounted) {
                                    GoRouter.of(context).goNamed(AppRouter.app);
                                  }
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: size.height / 11,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: const Color(0xFF21899C),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4C2E84)
                                          .withValues(alpha: 0.2),
                                      offset: const Offset(0, 15.0),
                                      blurRadius: 60.0,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'دخول',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),

                        //footer section. sign up text here
                        footerText(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget logo(double height_, double width_) {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: const Color(0xFF21899C),
          letterSpacing: 2.000000061035156,
        ),
        children: const [
          TextSpan(
            text: 'تسجيل ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: 'الدخول',
            style: TextStyle(
              color: Color(0xFFFE9879),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget footerText() {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: 12.0,
          color: const Color(0xFF3B4C68),
        ),
        children: const [
          TextSpan(
            text: 'تصميم و تنفيذ',
          ),
          TextSpan(
            text: ' ',
            style: TextStyle(
              color: Color(0xFFFF5844),
            ),
          ),
          TextSpan(
            text: 'د / كريم زاهر',
            style: TextStyle(
              color: Color(0xFFFF5844),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
