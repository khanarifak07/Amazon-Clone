String url = "http://192.168.0.107:8000/api/v1";
String registerApi = "$url/user/register";
String loginApi = "$url/user/login";
String logoutApi = "$url/user/logout";
String getCurrentUserApi = "$url/user/get-current-user";

String addProductApi = "$url/product/add-product";
String getAllProductsApi = "$url/product/products";
String deleteProductApi(String id) => "$url/product/delete-product/$id";
String getProductsByCategoryApi(String category) =>
    "$url/product/products-by-category?category=$category";
String searchProductApi(String searchkeyword) =>
    "$url/product/search-product/$searchkeyword";
String rateProductApi = "$url/product/rate-product";
String dealOfTheDayApi = "$url/product/deal-of-the-day";
