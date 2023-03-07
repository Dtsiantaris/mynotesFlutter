import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/constants/styles.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
        centerTitle: true,
      ),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            "We've sent you an email verification. Please click on the link to verify your account.",
            textAlign: TextAlign.center,
          ),
        ),
        const Text(
          "If you haven't received an email, press the button below.",
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: () {
            context
                .read<AuthBloc>()
                .add(const AuthEventSendEmailVerification());
          },
          child: const Text(
            'Send email verification',
          ),
        ),
        TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            },
            child: const Text(
              'When you verify, Log in here!',
            ))
      ]),
    );
  }
}
