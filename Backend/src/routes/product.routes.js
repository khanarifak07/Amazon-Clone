import { Router } from "express";
import {
  addProduct,
  deleteProduct,
  getAllProducts,
} from "../controllers/product.controller.js";
import { verifyJWT } from "../middlewares/auth.middleware.js";
import { upload } from "../middlewares/multer.middleware.js";

const router = Router();

//add product
router
  .route("/add-product")
  .post(verifyJWT, upload.array("images", 10), addProduct);
//get all products
router.route("/get-all-products").get(verifyJWT, getAllProducts);
//delete product
router.route("/delete-product/:prodId").delete(verifyJWT, deleteProduct);

export default router;
