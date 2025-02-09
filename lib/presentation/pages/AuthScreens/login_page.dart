import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_pad/config/route/routes_name.dart';
import 'package:media_pad/presentation/bloc/Authentication/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

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
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                padding: EdgeInsets.all(isWeb ? 40 : 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 40),
                    _buildEmailField(),
                    SizedBox(height: 20),
                    _buildPasswordField(),
                    SizedBox(height: 24),
                    _buildLoginButton(state),
                    SizedBox(height: 20),
                    _buildAdditionalOptions(),
                    if (isWeb) SizedBox(height: 40),
                    if (isWeb) _buildSocialLogin(),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } else if (state is Authenticated) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.notesList,
              (_) => false,
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.lock_person,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(height: 16),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Please sign in to continue',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        hintText: 'Enter your email',
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(),
        hintText: 'Enter your password',
      ),
    );
  }

  Widget _buildLoginButton(AuthState state) {
    return ElevatedButton(
      onPressed: state is AuthLoading
          ? null
          : () => context.read<AuthBloc>().add(
                LoginEvent(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                ),
              ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
      child: state is AuthLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text('Sign In'),
    );
  }

  Widget _buildAdditionalOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: Text('Forgot Password?'),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, RouteNames.register),
          child: Text('Create Account'),
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        Text(
          'Or continue with',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
        ),
        SizedBox(height: 16),
        IconButton(
          iconSize: 40,
          onPressed: () {},
          icon: Image.asset('assets/images/google_icon.png', width: 30,),
        ),
        SizedBox(width: 20),
      ],
    );
  }
}
