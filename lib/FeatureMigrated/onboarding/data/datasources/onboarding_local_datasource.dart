import '../../domain/entities/onboard_message.dart';

class OnboardingLocalDatasource {
  List<OnBoardMessage> getOnboardingMessages() {
    return [
      OnBoardMessage(
        imageSource: ['assets/image/peopleShoping.svg'],
        title: 'Welcome to GetNowShop',
        subTitle: "Shop smarter, live better. Discover quality items, trusted brands, and everything you need—all in one place.",
      ),
      OnBoardMessage(
        imageSource: ['assets/image/price-tag.png', 'assets/image/makingOrder.svg'],
        title: "Exclusive Deals, Just for You",
        subTitle: "Save more with daily discounts, flash sales, and time-limited offers.\nGet personalized product suggestions based on your shopping habits.\nWishlist your favorites and never miss a restock or a price drop.",
      ),
      OnBoardMessage(
        imageSource: ['assets/image/payment.png', 'assets/image/cargo-truck.png'],
        title: "Fast Delivery & Safe Payments",
        subTitle: "Enjoy same-day or next-day delivery in selected locations.\nChoose from flexible delivery options and real-time tracking\nPay securely using cards, wallets, or cash on delivery.",
      ),
      OnBoardMessage(
        imageSource: ['assets/image/ready.svg'],
        title: "You're All Set to Begin",
        subTitle: "Sign in to sync your wishlist and order history.\nTurn on notifications for hot deals and order updates.\nReady when you are—just one tap away from smarter shopping.",
      ),
    ];
  }
} 