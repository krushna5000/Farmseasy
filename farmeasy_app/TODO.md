# TODO: Connect Authentication APIs to Frontend

## Tasks
- [ ] Update auth_service.dart to add separate methods for login and register OTP operations
- [ ] Modify mobile_number_screen.dart to use sendLoginOtp and handle user not found error
- [ ] Update create_account_screen.dart to use sendRegisterOtp
- [ ] Modify otp_screen.dart to accept isLogin flag and use appropriate verify method
- [ ] Test the authentication flow in the app
- [ ] Consider adding token storage for session management
