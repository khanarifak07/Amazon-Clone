import mongoose, { Schema } from "mongoose";

const ratingSchema = new Schema({
  userId: {
    type: String,
    required: true,
  },
  rating: {
    type: Number,
    required: [true, "Why no Rating?"],
    min: 1,
    max: 5,
  },
});

const productSchema = new Schema(
  {
    name: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    price: {
      type: Number,
      required: true,
    },
    quantity: {
      type: Number,
      required: true,
    },
    category: {
      type: String,
      required: true,
    },
    images: [
      {
        type: String,
        required: true,
      },
    ],
    ratings: [ratingSchema],
  },
  { timestamps: true }
);

export const Product = mongoose.model("Product", productSchema);
