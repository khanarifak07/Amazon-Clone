import { Product } from "../models/product.model.js";
import { ApiError } from "../utils/ApiError.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/AsyncHandler.js";
import { uploadFileOnCloudinary } from "../utils/cloudinary.js";

const addProduct = asyncHandler(async (req, res) => {
  const { name, description, price, quantity, category } = req.body;

  if (
    [name, description, price, quantity, category].some(
      (fields) => fields.trim() === ""
    )
  ) {
    throw new ApiError(400, "All Fields are required");
  }

  const imagesLocalPaths = req.files.map((file) => file.path);
  console.log(`Image Local Path :- ${imagesLocalPaths}`);
  const imagesUrls = await Promise.all(
    imagesLocalPaths.map(uploadFileOnCloudinary)
  );
  console.log(`Image URLs :-  ${imagesUrls.map((url) => url.url)}`);

  // Check if all uploads were successful
  if (imagesUrls.every((url) => url !== null)) {
    // Use the array of image URLs when creating the product
    const product = await Product.create({
      name,
      description,
      price,
      quantity,
      category,
      images: imagesUrls.map((url) => url.url), // Assuming imagesUrls is an array of response objects
    });

    // Return the product with image URLs in the response
    return res
      .status(200)
      .json(new ApiResponse(200, product, "Product Added Successfully"));
  } else {
    // Handle the case where one or more uploads failed
    return res
      .status(500)
      .json(new ApiResponse(500, null, "Error uploading one or more images"));
  }
});

const getAllProducts = asyncHandler(async (_, res) => {
  const products = await Product.find();
  return res
    .status(200)
    .json(new ApiResponse(200, products, "All products fetched successfully"));
});

const deleteProduct = asyncHandler(async (req, res) => {
  //get the product id from params
  const prodId = req.params.prodId;
  const product = await Product.findById(prodId);
  if (!product) {
    throw new ApiError(400, "Product not found with this id");
  }

  const deletedProd = await Product.findByIdAndDelete(prodId);

  return res
    .status(200)
    .json(new ApiResponse(200, deletedProd, "Product deleted successfully"));
});

const getProductByCategory = asyncHandler(async (req, res) => {
  // /api/v1/product?category=Essentials
  // const category = req.params.category;
  const { category } = req.query;

  const products = await Product.find({ category: category });

  if (products.length === 0) {
    return res.status(404).json({
      status: 404,
      message: "No products found for the given category",
      success: false,
    });
  }

  return res
    .status(200)
    .json(
      new ApiResponse(
        200,
        products,
        "Product by category  fetched successfully"
      )
    );
});

const searchProduct = asyncHandler(async (req, res) => {
  // const search = req.body.search;
  const search = req.params.name;

  const searchProduct = await Product.find({
    name: { $regex: ".*" + search + ".*", $options: "i" },
  });
  if (searchProduct.length > 0) {
    return res
      .status(200)
      .json(
        new ApiResponse(200, searchProduct, "Product searched successfully")
      );
  } else {
    throw new ApiError(404, "No product found");
  }
});

const rateProduct = asyncHandler(async (req, res) => {
  // const prodId = req.params.prodId;
  const userId = req.user?._id;
  const { prodId, rating } = req.body;
  let product = await Product.findById(prodId);
  if (!product) {
    throw new ApiError(400, "Product not found");
  }
  for (let i = 0; i < product.ratings.length; i++) {
    if (product.ratings[i].userId == userId) {
      product.ratings.splice(i, 1);
      break;
    }
  }
  const ratingSchema = {
    userId: userId,
    rating,
  };
  product.ratings.push(ratingSchema);
  product = await product.save();
  return res.status(200).json(new ApiResponse(200, product, "Rating Given"));
});

//get the deals of the day product based on highest ratings
const dealOfTheDayProduct = asyncHandler(async (req, res) => {
  let products = await Product.find(); //get all the products
  products = products.sort((a, b) => {
    let aSum = 0;
    let bSum = 0;

    for (let i = 0; i < a.ratings.length; i++) {
      aSum += a.ratings[i].rating;
    }

    for (let i = 0; i < b.ratings.length; i++) {
      bSum != b.ratings[i].rating;
    }

    return aSum < bSum ? 1 : -1;
  });

  return res
    .status(200)
    .json(new ApiResponse(200, products[0], "Deal of the day product"));
});
export {
  addProduct,
  dealOfTheDayProduct,
  deleteProduct,
  getAllProducts,
  getProductByCategory,
  rateProduct,
  searchProduct,
};
