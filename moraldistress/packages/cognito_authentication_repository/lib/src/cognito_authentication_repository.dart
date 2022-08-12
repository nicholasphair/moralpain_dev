import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class CognitoAuthenticationRepository {
  Future<String> fetchUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes().timeout(
        Duration(seconds: 15),
        onTimeout: () =>
            throw Exception('failed to fetch attributes in reasonable time'),
      );
      final subAttribute = attributes
          .firstWhere((element) => element.userAttributeKey.key == 'sub');
      final userId = subAttribute.value;
      return userId;
    } on NotAuthorizedException catch (e) {
      throw e;
    } catch (e) {
      print('unexpected exception ${e}');
      throw e;
    }
  }

  // Proxy for verifying authorization - should hit /userInfo with an
  // access token.
  Future<bool> isAuthorized() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes()
          .timeout(Duration(seconds: 15));
      return attributes.isNotEmpty;
    } on NotAuthorizedException {
      return false;
    } on TimeoutException {
      return false;
    } catch (e) {
      print('unexpected exception ${e}');
      throw e;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ).timeout(Duration(seconds: 15));
      return session.isSignedIn;
    } on SessionExpiredException {
      return false;
    } on SignedOutException {
      return false;
    } on TimeoutException {
      return false;
    } on NotAuthorizedException {
      return false;
    } catch (e) {
      print('unexpected exception ${e}');
      throw e;
    }
  }

  Future<AWSCredentials> fetchUserCredentials() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      ).timeout(Duration(seconds: 15)) as CognitoAuthSession;
      return session.credentials!;
    } catch (e) {
      print('failed to fetch user credentials');
      throw e;
    }
  }

  Future<bool> signInPrivateSession() async {
    final result = await Amplify.Auth.signInWithWebUI(
        options:
            const CognitoSignInWithWebUIOptions(isPreferPrivateSession: true));
    return result.isSignedIn;
  }

  Future<bool> signIn() async {
    final result = await Amplify.Auth.signInWithWebUI();
    return result.isSignedIn;
  }

  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      throw e;
    }
  }

  // Async generator
  Stream<AWSCredentials> latestCredentialGenerator() async* {
    while (true) {
      try {
        final session = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true),
        ) as CognitoAuthSession;
        yield session.credentials!;
      } catch (e) {
        print('unexpected exception ${e}');
        throw e;
      }
      await Future<void>.delayed(const Duration(minutes: 1));
    }
  }
}
