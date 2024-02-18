import { Router } from "express";
import {
  addProduct,
  addToCart,
  dealOfTheDayProduct,
  deleteProduct,
  getAllProducts,
  getProductByCategory,
  rateProduct,
  searchProduct,
} from "../controllers/product.controller.js";
import { verifyJWT } from "../middlewares/auth.middleware.js";
import { upload } from "../middlewares/multer.middleware.js";

const router = Router();

//add product
router
  .route("/add-product")
  .post(verifyJWT, upload.array("images", 10), addProduct);
//get all products
router.route("/products").get(verifyJWT, getAllProducts);
//delete product
router.route("/delete-product/:prodId").delete(verifyJWT, deleteProduct);
//get product by category
//api/v1/products:category=Mobiles --> req.params.category
//api/v1/products?category=Mobiles --> req.query.category
// router.route("/products-by-category/:category").get(verifyJWT, getProductByCategory);
router.route("/products-by-category").get(verifyJWT, getProductByCategory);
//search product
router.route("/search-product/:name").get(verifyJWT, searchProduct);
//rating product
router.route("/rate-product").post(verifyJWT, rateProduct);
//deal of the day product
router.route("/deal-of-the-day").get(verifyJWT, dealOfTheDayProduct);
//add to cart
router.route("/add-to-cart").post(verifyJWT, addToCart);

export default router;
