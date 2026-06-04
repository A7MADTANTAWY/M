import 'package:flutter/material.dart';
import 'package:mongez/features/auth/bloc/login_cubit/auth_cubit.dart';
import 'package:mongez/features/auth/screens/register_screen.dart';
import 'package:mongez/generated/l10n.dart';
import 'package:mongez/services/navigation_service.dart';
import 'package:mongez/widgets/custom_button.dart';
import 'package:mongez/widgets/custom_text_form_field.dart';
import 'package:mongez/widgets/logo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          NavigationService.toMainScreen(context, state.auth);
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    const Logo(),
                    const SizedBox(height: 170),

                    /// Username Field
                    CustomFormField(
                      controller: usernameController,
                      hintText: lang.email,
                      keyboardType: TextInputType.text,
                      preIcon: Icon(
                        Icons.person,
                        color: textTheme.bodySmall?.color,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return lang.pleaseEnterYourEmail;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    /// Password Field
                    CustomFormField(
                      controller: passwordController,
                      hintText: lang.password,
                      obscureText: true,
                      preIcon: Icon(
                        Icons.lock,
                        color: textTheme.bodySmall?.color,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return lang.pleaseEnterYourPassword;
                        }
                        if (value.length < 6) return lang.passwordTooShort;
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),

                    /// Login Button
                    state is LoginLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            text: lang.login,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginCubit>().login(
                                  userName: usernameController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                              }
                            },
                            backgroundColor: colorScheme.primary,
                            textColor: colorScheme.onPrimary,
                          ),
                    const SizedBox(height: 20),

                    /// Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${lang.dontHaveAccount} ',
                          style: textTheme.bodyMedium?.copyWith(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            lang.signUp,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

