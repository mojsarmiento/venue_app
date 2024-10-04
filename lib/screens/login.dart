import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venue_app/bloc/login_bloc.dart'; // Import your LoginBloc
import 'package:venue_app/bloc/login_event.dart'; // Import LoginEvent
import 'package:venue_app/bloc/login_state.dart'; // Import LoginState
import 'package:venue_app/services/api_service.dart'; // Import your ApiService
import 'package:venue_app/screens/admin/admin_home.dart'; // Corrected import for AdminScreen
import 'package:venue_app/screens/user/home.dart'; // Adjust this import based on your file structure
import 'package:venue_app/widgets/custom_button.dart';
import 'register.dart';
import 'forgotpassword.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(apiService: ApiService()),
      child: const LoginScreenBody(),
    );
  }
}

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  LoginScreenBodyState createState() => LoginScreenBodyState();
}

class LoginScreenBodyState extends State<LoginScreenBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Password visibility toggle
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate email and password fields
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email and password cannot be empty.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    BlocProvider.of<LoginBloc>(context).add(
      LoginButtonPressed(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00008B), Color(0xFF5D3FD3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) async {
                if (state is LoginSuccess) {
                  // Store user email and userType in SharedPreferences
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('email', state.email);
                  await prefs.setString('userType', state.userType ?? '');

                  // Show success message based on user type
                  String successMessage;
                  if (state.userType == 'admin') {
                    successMessage = 'Admin Login Successful';
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminScreen()),
                    );
                  } else if (state.userType == 'reserver') {
                    successMessage = 'Reserver Login Successful';
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  } else {
                    successMessage = 'Login Successful';
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  }

                  // Display the success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(successMessage),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is LoginFailure) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.error.contains('password')
                            ? 'Wrong Password'
                            : 'Login failed: ${state.error}',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is LoginLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/venue_vista_logo.png',
                      height: 150,
                      width: 150,
                      alignment: Alignment.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Log in to continue',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Log In',
                      onPressed: _login,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      child: const Text('Forgot Password?'),
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.white),
                      child: const Text('Register Now'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}













