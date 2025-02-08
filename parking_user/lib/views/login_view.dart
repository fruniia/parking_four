import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:parking_user/views/index.dart';
import 'package:parking_user/widgets/index.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _key = GlobalKey<FormState>();
  final TextEditingController _ssnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Center(
      child: Form(
        key: _key,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to \nParking app'),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _ssnController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.abc_rounded),
                    labelText: 'Socialsecuritynumber'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter socialsecuritynumber';
                  }
                  if (!isValidLuhn(value)) {
                    return 'Invalid ssn';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              const PasswordField(),
              const SizedBox(
                height: 16,
              ),
              Builder(builder: (context) {
                return ElevatedButton(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        try {
                          await authProvider.login(_ssnController.text);

                          if (authProvider.status ==
                              UserAuthStatus.authenticated) {
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NavigationView()));
                            }
                          } else if (authProvider.status ==
                              UserAuthStatus.notAuthenticated) {
                            if (context.mounted) {
                              showCustomSnackBar(context,
                                  'Authentication failed. Invalid SSN.',
                                  type: 'error');
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            showCustomSnackBar(
                                context, 'Error: ${e.toString()}',
                                type: 'error');
                          }
                        }
                      }
                    },
                    child: const Text('Login'));
              }),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationWidget(),
                    ),
                  );
                },
                child: const Text(
                  'Don\'t have an account? Register here.',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
