import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tailme/presentation/AddAddress/add_address.dart';
import 'package:tailme/presentation/EditAddress/edit_address.dart';
import 'package:tailme/presentation/SavedAddress/popup_function/popup_dialog.dart';
import 'package:tailme/theme_util.dart';

import '../../application/AddAddress/add_address_bloc.dart';
import '../../domain/AddAddress/model/address_model.dart';

class ScreenSavedAddress extends StatelessWidget {
  ScreenSavedAddress({super.key});

  Position? location;

  List<Placemark>? placemark;

  bool isLoading = true;
  // Loading state to show progress indicator
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeUtil.isDarkMode(context);
    debugPrint("i came again");
    BlocProvider.of<AddAddressBloc>(context)
        .add(const AddAddressEvent.getAllAddress());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SvgPicture.asset(
              'assets/images/back_arrow.svg',
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        title: Text(
          'Saved Addresses',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 15,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 24.w, left: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: ShapeDecoration(
                    color: isDarkMode ? Color(0x99D9D9D9) : Color(0xB20075BE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 12.w, right: 12.w, top: 15.h, bottom: 9.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            BlocProvider.of<AddAddressBloc>(context).add(
                                const AddAddressEvent.getCurrentLocation());
                          },
                          child: Row(
                            children: [
                              // Icon(Icons.add_location_alt_outlined,size: 20.h,color: Colors.white,),
                              SvgPicture.asset(
                                'assets/images/current_location.svg',
                                height: 20.h,
                                width: 20.h,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              const Text(
                                'Use current location',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              )
                              // SvgPicture.asset(
                              //   'assets/images/arrow_left.svg',
                              //   height: 17.h,
                              //   width: 17.h,
                              // ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black.withOpacity(0.36000001430511475),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ScreenEnterCompleteAddress(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              const Text(
                                'Add address',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.white,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 17.h,
                ),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Text(
                      'Saved Addresses',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 15,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w800,
                        height: 0.07,
                      ),
                    ),
                    const Expanded(child: Divider())
                  ],
                ),
                SizedBox(
                  height: 40.h,
                ),
                BlocConsumer<AddAddressBloc, AddAddressState>(
                  listener: (context, state) {
                    state.isDataGot.fold(() {}, (some) {
                      some.fold((f) {
                        final message = f.maybeWhen(
                          validationFailure: () =>
                              "Enter correct data, please recheck",
                          userNotFound: () =>
                              "Credentials..Login again and check",
                          networkFailure: () => "Network Issue!! Try Again",
                          orElse: () => "Some error occurred",
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          message,
                          style: const TextStyle(color: Colors.red),
                        )));
                      }, (s) {});
                    });

                    state.isEditDataGot.fold(() {}, (some) {
                      some.fold((f) {
                        final message = f.maybeWhen(
                          userNotFound: () =>
                              "Credentials..Login again and check",
                          networkFailure: () => "Network Issue!! Try Again",
                          orElse: () => "Some error occurred",
                        );
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          message,
                          style: const TextStyle(color: Colors.red),
                        )));
                      }, (s) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ScreenEditAddress(
                                  address: state.addressess,
                                )));
                      });
                    });
                  },
                  builder: (context, state) {
                    if (state.isGettingAddress) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.blue,
                      ));
                    }
                    final addressModel = state.addressess;
                    return Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => Column(
                          children: [
                            SizedBox(
                              height: 8.h,
                            ),
                            Divider(
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                            SizedBox(
                              height: 8.h,
                            ),
                          ],
                        ), // Separator
                        itemCount: addressModel.addresses.length,
                        itemBuilder: (context, index) {
                          final address = addressModel.addresses[index];
                          final addressType = typeValues.reverse[address.type];
                          return SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.push_pin_outlined,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                    SizedBox(width: 10.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          addressType.toString().toUpperCase(),
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          '${address.flat}, ${address.area}\n${address.pincode}',
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Raleway',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    const SizedBox(width: 28),
                                    GestureDetector(
                                      onTap: () {
                                        print(
                                            "recovery address is: ${state.addressess.toJson()}");
                                        BlocProvider.of<AddAddressBloc>(context)
                                            .add(AddAddressEvent
                                                .editButtonPressedEvent(
                                                    adddressId:
                                                        address.addressId,
                                                    address: state.addressess));
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             const ScreenEditAddress()));
                                      },
                                      child: Container(
                                        width: 74,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0075BE),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.edit_note,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontFamily: 'Raleway',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15.w),
                                    BlocConsumer<AddAddressBloc,
                                        AddAddressState>(
                                      listener: (context, state) {
                                        state.successOrfailure.fold(() {},
                                            (some) {
                                          some.fold((f) {
                                            final message = f.maybeWhen(
                                              validationFailure: () =>
                                                  "Enter correct data, please recheck",
                                              userNotFound: () =>
                                                  "Credentials..Login again and check",
                                              networkFailure: () =>
                                                  "Network Issue!! Try Again",
                                              orElse: () =>
                                                  "Some error occurred",
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(message,
                                                      style: const TextStyle(
                                                          color: Colors.red))),
                                            );
                                          }, (s) {
                                            BlocProvider.of<AddAddressBloc>(
                                                    context)
                                                .add(const AddAddressEvent
                                                    .getAllAddress());
                                          });
                                        });
                                      },
                                      builder: (context, state) {
                                        return GestureDetector(
                                          onTap: () {
                                            showDeleteConfirmationDialog(
                                                context,
                                                addressId: address.addressId);
                                          },
                                          child: Container(
                                            width: 74,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFF0000),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/delete.svg',
                                                  color: Colors.white,
                                                ),
                                                const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontFamily: 'Raleway',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          BlocConsumer<AddAddressBloc, AddAddressState>(
            listener: (context, state) {
              state.isNavigate
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScreenEnterCompleteAddress(
                                locality: state.locality,
                                pinCode: state.pinCode,
                                landMark: state.landmark,
                              )))
                  : print("hello");
            },
            builder: (context, state) {
              if (state.isLocationLoading) {
                print(state.landmark);
                return Center(
                  child: LoadingAnimationWidget.stretchedDots(
                    color: Colors.blue,
                    size: 100,
                  ),
                );
              } else {
                return const Center();
              }
            },
          ),
        ],
      ),
    );
  }
}
