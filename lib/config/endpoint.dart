class APIEndPoint {
  // static const String _baseEndPoint = "https://ecommerce-renderer.onrender.com/api";
     static const String _baseEndPoint = "http://192.168.0.110:3000/api";
   static const String productGetEndPoint = "$_baseEndPoint/products";
   static const String addCartScreenEndPoint = "$_baseEndPoint/carts/:userId";
   static const String favouriteScreenEndPoint = "$_baseEndPoint/favourites/:userId";
   static const String postcartsDataEndPoint = "$_baseEndPoint/carts";
   static const String updateCartQuantity = "$_baseEndPoint/update-card-quantity";
   static const String postfavouriteData = "$_baseEndPoint/favourites";
   static const String saveAddress = "$_baseEndPoint/address";
   static const String getCartsData = "$_baseEndPoint/carts";
   static const String deleteCartData = "$_baseEndPoint/carts";
   static const String deleteFavouriteData = "$_baseEndPoint/favourites";
   static const String getFavouriteData = "$_baseEndPoint/favourites";
   static const String getAddressData = "$_baseEndPoint/address";
   static const String fetchMyAllOrders = "$_baseEndPoint/myorders";
   static const String getOrderItems = "$_baseEndPoint/orderitems";
   static const String fetchUserOrders = "$_baseEndPoint/myorders";
   static const String postSignUpData = "$_baseEndPoint/signup";
   static const String userLogin = "$_baseEndPoint/login";
static const String fetchMyAllReviews = "$_baseEndPoint/myallreviews";
static const String getReviews= _baseEndPoint;
static const String postReviews= _baseEndPoint;
 }