import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:parking_user/views/index.dart';
import 'package:provider/provider.dart';

class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({super.key});

  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ssnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration view'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child:
              Consumer<AuthProvider>(builder: (context, authProvider, child) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ssnController,
                    decoration:
                        InputDecoration(labelText: 'Social Security Number'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your SSN\nYYYYMMDDXXXX';
                      }
                      if (!isValidLuhn(value)) {
                        return 'Invalid SSN';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final ssn = _ssnController.text;
                        final name = _nameController.text;
                        try {
                          await authProvider.register(ssn, name);

                          if (context.mounted) {
                            showCustomSnackBar(
                                context, 'Registration succeeded',
                                type: 'success');
                          }

                          if (context.mounted) {
                            await authProvider
                                .authenticateAfterRegistration(ssn);
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NavigationView()));
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            showCustomSnackBar(
                                context, 'Registration failed:\n$e',
                                type: 'error');
                          }
                        }
                      }
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
