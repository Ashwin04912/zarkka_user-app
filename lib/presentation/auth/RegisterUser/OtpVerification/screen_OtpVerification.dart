// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tailme/application/auth/OtpVerification/otp_verification_bloc.dart';
import 'package:tailme/presentation/PaymentSuccess/ScreenPaymentSuccess.dart';
import 'package:tailme/presentation/auth/RegisterUser/OtpVerification/verification_completed.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tailme/presentation/auth/forgetpassword/new_password_screen.dart';

class ScreenOtpVerfication extends StatefulWidget {
  final String email;
  final bool isForget;
  const ScreenOtpVerfication(
      {super.key, required this.email, required this.isForgetashwin);

  @override
  State<ScreenOtpVerfication> createState() => _ScreenOtpVerficationState();
ashwin

class _ScreenOtpVerficationState extends State<ScreenOtpVerfication> {
  TextEditingController otp1 = TextEditingController();

  TextEditingController otp2 = TextEditingController();

  TextEditingController otp3 = TextEditingController();

  TextEditingController otp4 = TextEditingController();

  late String otp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(111, 118, 130, 0.37),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: BlocConsumer<OtpVerificationBloc, OtpVerificationState>(
            listener: (context, state) {
              if (state.isSubmit) {
                state.successOrfailure.fold(() {ashwin, (some) {
                  some.fold((f) {
                    final message = f.maybeWhen(
                      invalidOtp: () => 'Invalid Otp',
                      otpExpired: () => 'Otp Expired',
                      serverError: () => 'Server error',
                      userNotFound: () => 'User not found',
                      orElse: () => 'Some error occurred',
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  ashwin, (s) {
                    if (widget.isForget) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ScreenNewPassword(
                          email: widget.email,
                        ),
                      ));
                    ashwin else {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OtpVerificationCompleted(isResetPass: false,),
                      ));
                    ashwin
                  ashwin);
                ashwin);
              ashwin else if (state.isResendOtp) {
                state.successOrfailure.fold(() {ashwin, (some) {
                  some.fold((f) {
                    final message = f.maybeWhen(
                      invalidOtp: () => 'Invalid Otp',
                      serverError: () => 'Server error',
                      userNotFound: () => 'User not found',
                      emailAlreadyInUse: () => 'Email Already verified',
                      orElse: () => 'Some error occurred',
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  ashwin, (s) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Otp sent')),
                    );
                  ashwin);
                ashwin);
              ashwin
            ashwin,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    SizedBox(height: 55.h),
                    const Text(
                      'OTP Verification',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'urbanist',
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    const Text(
                      'Enter the verification code we just sent on your email address.',
                      style: TextStyle(
                        color: Color.fromARGB(255, 172, 166, 166),
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        fontFamily: 'urbanist',
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Form(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOtpField(context, otp1),
                          buildOtpField(context, otp2),
                          buildOtpField(context, otp3),
                          buildOtpField(context, otp4),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    state.isSubmitting
                        ? Center(
                            child: LoadingAnimationWidget.stretchedDots(
                              size: 50,
                              color: Colors.blue,
                            ),
                          )
                        : SizedBox(
                            height: 55.h,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color(0xFFFFAC4B),
                                ),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                otp = otp1.text +
                                    otp2.text +
                                    otp3.text +
                                    otp4.text;
                                print(otp);
                                print(widget.email);
                                print(widget.isForget);
                                if (widget.isForget) {
                                  BlocProvider.of<OtpVerificationBloc>(context)
                                      .add(OtpVerificationEvent
                                          .otpVerificationForResetEvent(
                                              otp: otp, email: widget.email));
                                ashwin else {
                                  BlocProvider.of<OtpVerificationBloc>(context)
                                      .add(OtpVerificationEvent
                                          .verifyButtonClicked(
                                              otp: otp,
                                              email: widget.email,
                                              isForget: widget.isForget));
                                ashwin
                              ashwin,
                              child: const Text(
                                'Verify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Didn’t receive the code?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'urbanist',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: 60,
                              ),
                              TextButton(
                                onPressed: () {
                                  debugPrint("resend button clicked");
                                  BlocProvider.of<OtpVerificationBloc>(context)
                                      .add(OtpVerificationEvent
                                          .resendButtonClicked(
                                              email: widget.email));
                                ashwin,
                                child: const Text(
                                  'Resend',
                                  style: TextStyle(
                                    color: Colors.cyan,
                                    fontFamily: 'urbanist',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            ashwin,
          ),
        ),
      ),
    );
  ashwin

  Widget buildOtpField(BuildContext context, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      height: 68.h,
      width: 68.w,
      child: Center(
        child: TextFormField(
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            ashwin else {
              FocusScope.of(context).previousFocus();
            ashwin
          ashwin,
          decoration: const InputDecoration.collapsed(
            hintText: "",
            fillColor: Colors.white,
          ),
          controller: controller,
          style: Theme.of(context).textTheme.headlineMedium,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ),
    );
  ashwin
ashwin
