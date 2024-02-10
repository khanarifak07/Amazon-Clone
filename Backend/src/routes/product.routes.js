import { Router } from "express";
import {
  addProduct,
  deleteProduct,
  getAllProducts,
  getProductByCategory,
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

export default router;
