import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/booking/booking_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:velocity_x/velocity_x.dart';

class BookingView extends StatelessWidget {
  final AppUser user;
  final ShopService service;
  const BookingView({Key? key, required this.user, required this.service})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final focusNode = useFocusNode();
    // var size = MediaQuery.of(context).size;
    return ViewModelBuilder<BookingViewModel>.reactive(
      onModelReady: (model) => model.init(
        isDark: getThemeManager(context).selectedThemeMode == ThemeMode.dark,
      ),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
              appBar: AppBar(
                title: "Edit Booking Calendar".text.make(),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width,
                      child: BookingCalendar(
                        bookingService: model.mockBookingService,
                        getBookingStream: model.getBookingStreamMock,
                        uploadBooking: model.uploadBookingMock,
                        convertStreamResultToDateTimeRanges:
                            model.convertStreamResultMock,
                        pauseSlots: model.pauseSlots,
                        pauseSlotText: 'LUNCH',
                        availableSlotColor: Colors.white,
                        bookingButtonText: service.name +
                            '(' +
                            '£' +
                            service.price.toString() +
                            ')',
                        uploadingWidget: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 20),
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              color: Color(4286745852),
                              strokeWidth: 10,
                            )),
                      ),
                    ),
                  ),
                  if (model.isSending) const BusyLoader(busy: true)
                ],
              )),
      viewModelBuilder: () => BookingViewModel(
        user,
        service,
      ),
    );
  }
}
