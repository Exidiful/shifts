import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController smsCodeController = TextEditingController();
  String? verificationId;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            if (verificationId == null)
              ElevatedButton(
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        final verId = await ref
                            .read(authControllerProvider.notifier)
                            .signIn(phoneController.text);
                        if (verId != null && mounted) {
                          // Only refresh state if verId is not null
                          setState(() {
                            verificationId = verId;
                          });
                        }
                      },
                child: authState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Send Verification Code'),
              )
            else
              Column(
                children: [
                  TextField(
                    controller: smsCodeController,
                    decoration: const InputDecoration(
                      labelText: 'SMS Code',
                      hintText: 'Enter the SMS code',
                      prefixIcon: Icon(Icons.sms),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: authState.isLoading
                        ? null
                        : () {
                            ref.read(authControllerProvider.notifier).verifySmsCode(
                                  verificationId!,
                                  smsCodeController.text,
                                );
                          },
                    child: authState.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Verify SMS Code'),
                  ),
                ],
              ),
            if (authState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Error: ${authState.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}