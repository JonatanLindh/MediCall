import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicall/app/routes.dart';
import 'package:medicall/screens/patient/login/bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String _email = '';
  String _password = '';

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      context.read<LoginBloc>().add(
            LoginButtonPressed(email: _email, password: _password),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          if (state.isDoctor) {
            DoctorHomeRoute().go(context);
          } else {
            PatientDashboardRoute().go(context);
          }
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  InputField(
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    onSaved: (value) => _email = value!,
                    validator: (value) =>
                        (value == null || !value.contains('@'))
                            ? 'Enter a valid email'
                            : null,
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.key),
                    keyboardType: TextInputType.text,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(
                          () => _obscurePassword = !_obscurePassword,
                        );
                      },
                    ),
                    validator: (value) => (value == null || value.length < 6)
                        ? 'Minimum 6 characters'
                        : null,
                    onSaved: (value) => _password = value!,
                    obscureText: _obscurePassword,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: (context.watch<LoginBloc>().state.isDoctor
                              ? Theme.of(context).colorScheme.onSecondary
                              : Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: (context.watch<LoginBloc>().state.isDoctor
                                ? Theme.of(context).colorScheme.onSecondary
                                : Theme.of(context).colorScheme.primary),
                          ),
                        );
                      } else {
                        return SubmitButton(onSubmit: _submit);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const SignUpButton(),
                  const LoginAsDoctorButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    required this.hintText,
    this.onSaved,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.emailAddress,
    super.key,
  });
  final String hintText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        fillColor: (context.watch<LoginBloc>().state.isDoctor
                ? Theme.of(context).colorScheme.onSecondary
                : Theme.of(context).colorScheme.primary)
            .withAlpha(0x2F),
        filled: true,
        hintText: hintText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({required this.onSubmit, super.key});
  final void Function(BuildContext) onSubmit;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onSubmit(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: (context.watch<LoginBloc>().state.isDoctor
            ? Theme.of(context).colorScheme.onSecondary
            : Theme.of(context).colorScheme.primary),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: 80,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Text('Sign In as ${state.isDoctor ? 'Doctor' : 'Patient'}');
        },
      ),
    );
  }
}

class LoginAsDoctorButton extends StatelessWidget {
  const LoginAsDoctorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<LoginBloc>().add(
              ToggleIsDoctor(),
            );
      },
      style: TextButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
      ),
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Text(
            'Log in as ${state.isDoctor ? 'Patient' : 'Doctor'}',
            style: TextStyle(
              color: (context.watch<LoginBloc>().state.isDoctor
                  ? Theme.of(context).colorScheme.onSecondary
                  : Theme.of(context).colorScheme.primary),
            ),
          );
        },
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          (context.watch<LoginBloc>().state.isDoctor
                  ? Theme.of(context).colorScheme.onSecondary
                  : Theme.of(context).colorScheme.primary)
              .withAlpha(0x2F),
        ),
      ),
      onPressed: () {
        RegisterRoute().push<void>(context);
      },
      child: Text(
        'Sign up',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
