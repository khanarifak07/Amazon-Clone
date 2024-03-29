import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import mongoose, { Schema } from "mongoose";
import productSchema from "./product.model.js";

const userSchema = new Schema(
  {
    username: {
      type: String,
      required: true,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      trim: true,
      validate: {
        validator: (value) => {
          const re =
            /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
          return value.match(re);
        },
        message: "Please enter a valid email",
      },
    },
    password: {
      type: String,
      required: [true, "Password is required"],
      validate: {
        validator: (value) => {
          return value.length >= 6;
        },
        message: "Password should contain atleast 6 characters",
      },
    },
    address: {
      type: String,
      default: "",
    },
    type: {
      type: String,
      default: "user",
    },
    refreshToken: {
      type: String,
    },
    cart: [
      {
        product: productSchema,
        quantity: {
          type: Number,
          default: 1,
        },
      },
    ],
  },
  { timestamps: true, versionKey: false }
);

//hashing password using bcrypt and pre hook
userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

//compare password using bcrypt and custom methods
userSchema.methods.isPasswordCorrect = async function (password) {
  return await bcrypt.compare(password, this.password);
};

//generate access token using jwt and cutom methods
userSchema.methods.generateAccessToken = async function () {
  return jwt.sign(
    {
      _id: this.id,
      username: this.username,
      email: this.email,
    },
    process.env.ACCESS_TOKEN,
    {
      expiresIn: process.env.ACCESS_TOKEN_EXPIRY,
    }
  );
};

//generate access token using jwt and cutom methods
userSchema.methods.generateRefreshToken = async function () {
  return jwt.sign(
    {
      _id: this.id,
    },
    process.env.REFRESH_TOKEN,
    {
      expiresIn: process.env.REFRESH_TOKEN_EXPIRY,
    }
  );
};

export const User = mongoose.model("User", userSchema);
