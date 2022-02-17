const rootRoute = "/";

const overviewPageDisplayName = "Bosh oyna";
const overviewPageRoute = "/home";

const driversPageDisplayName = "Ma'lumotlar ombori";
const driversPageRoute = "/database";

const clientsPageDisplayName = "Kordinatolar jadvali";
const clientsPageRoute = "/tabel";

const ladeInfoPageDisplayName = "Kanal parametirlari";
const ladeInfoPageRoute = "/ladeInfo";

const userInfoPageDisplayName = "Foydalanuvchi ma'lumotlari";
const userInfoPageRoute = "/userInfo";

const authenticationPageDisplayName = "Log out";
const authenticationPageRoute = "/auth";

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}

List<MenuItem> sideMenuItemRoutes = [
  MenuItem(overviewPageDisplayName, overviewPageRoute),
  MenuItem(driversPageDisplayName, driversPageRoute),
  MenuItem(ladeInfoPageDisplayName, ladeInfoPageRoute),
  MenuItem(userInfoPageDisplayName, userInfoPageRoute),
  MenuItem(authenticationPageDisplayName, authenticationPageRoute),
];
