import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseApi = locator<DatabaseApi>();

  List<Shop> searchedShops = [];

  late List<Shop> allShops;
  late List<AppUser> shopOwners;
  late List<ShopService> allServices;

  void init() {
    setBusy(true);

    _listenAllShops();
    _listenShopOwners();
    _listenAllServices();

    setBusy(false);
  }

  void _listenAllShops() {
    _databaseApi.listenShops().listen(
      (shopsData) {
        allShops = shopsData;
        notifyListeners();
      },
    );
  }

  void _listenShopOwners() {
    _databaseApi.listenShopOwners().listen(
      (users) {
        shopOwners = users;
        notifyListeners();
      },
    );
  }

  void _listenAllServices() {
    _databaseApi.listenAllServices().listen(
      (servicesData) {
        allServices = servicesData;
        notifyListeners();
      },
    );
  }

  void onSearchTextChanged(String text) {
    searchedShops.clear();
    if (text.isEmpty) {
      notifyListeners();
      return;
    }

    // ignore: avoid_function_literals_in_foreach_calls
    allShops.forEach((shop) {
      if (shop.name
          .trim()
          .replaceAll(' ', '')
          .toLowerCase()
          .contains(text.trim().replaceAll(' ', '').toLowerCase())) {
        searchedShops.add(shop);
        notifyListeners();
        return;
      } else {
        searchedShops.remove(shop);
        notifyListeners();
        return;
      }
    });
  }

  Future navigateToShopView({
    required Shop shop,
    required AppUser owner,
    required List<ShopService> services,
  }) async {
    await _navigationService.navigateTo(
      Routes.sellerProfileView,
      arguments: SellerProfileViewArguments(
        seller: owner,
      ),
    );
  }
}
