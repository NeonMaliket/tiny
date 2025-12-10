import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:tiny/components/cyberpunk/cyberpunk_background.dart';
import 'package:tiny/components/cyberpunk/cyberpunk_text.dart';
import 'package:tiny/config/logger.dart';

const String redirectUrl = 'farum-azula.tiny://callback';

class LoginWindow extends StatelessWidget {
  const LoginWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const CyberpunkText(text: 'Login'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CyberpunkBackground(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SupaEmailAuth(
                    isInitiallySigningIn: true,
                    redirectTo: redirectUrl,
                    onSignInComplete: (response) {
                      context.go('/login');
                    },
                    onSignUpComplete: (response) {
                      context.go('/login');
                    },
                    metadataFields: [
                      MetaDataField(
                        prefixIcon: const Icon(Icons.person),
                        label: 'Username',
                        key: 'username',
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter something';
                          }
                          return null;
                        },
                      ),
                      BooleanMetaDataField(
                        key: 'terms_agreement',
                        isRequired: true,
                        checkboxPosition:
                            ListTileControlAffinity.leading,
                        richLabelSpans: [
                          const TextSpan(
                            text: 'I have read and agree to the ',
                          ),
                          TextSpan(
                            text: 'Terms and Conditions',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  SupaSocialsAuth(
                    colored: true,
                    redirectUrl: redirectUrl,
                    socialButtonVariant: SocialButtonVariant.icon,
                    socialProviders: [
                      Platform.isIOS
                          ? OAuthProvider.apple
                          : OAuthProvider.google,
                    ],
                    onSuccess: (Session response) {
                      context.go('/chat/list');
                    },
                    onError: (error) {
                      logger.error('Login error: $error');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
