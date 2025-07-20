import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String token = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.standard(); // Updated constructor

  AuthBloc() : super(AuthStateInitial()) {
    on<FirebaseSignUpEvent>(_firebaseSignUpEvent);
    on<CheckAuthStatusEvent>(_checkAuthStatusEvent);
    
    // Check auth status when bloc is created
    add(CheckAuthStatusEvent());
  }

  FutureOr<void> _firebaseSignUpEvent(
    FirebaseSignUpEvent event, 
    Emitter<AuthState> emit
  ) async {
    try {
      emit(FirebaseAuthLoadingState());
      
      // Trigger the Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }
      
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      
      if (user != null) {
        emit(FirebaseAuthSuccessState(user: user));
      } else {
        emit(FirebaseAuthFailedState(message: 'Sign in failed - no user returned'));
      }
    } on FirebaseAuthException catch (e) {
      emit(FirebaseAuthFailedState(message: e.message ?? 'Authentication failed'));
    } catch (e) {
      emit(FirebaseAuthFailedState(message: e.toString()));
    }
  }

  FutureOr<void> _checkAuthStatusEvent(
    CheckAuthStatusEvent event, 
    Emitter<AuthState> emit
  ) async {
    await Future.delayed(const Duration(seconds: 1)); // Optional delay for splash screen
    
    final User? user = _auth.currentUser;
    if (user != null) {
      emit(UserAuthenticatedState(user: user));
    } else {
      emit(UserNotAuthenticatedState());
    }
  }
}