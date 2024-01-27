import jwt from "jsonwebtoken";
import { User } from "../models/user.model.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/AsyncHandler.js";

const verifyJWT = asyncHandler(async (req, _, next) => {
  //take the cookies from access token or header
  //verify and decode the token via jwt verify
  //now get the user id from that decoded token
  //inject user to req.user
  //return response
  try {
    const accessToken =
      req.cookies?.accessToken ||
      req.header("Authorization")?.replace("Bearer", "");
    if (!accessToken) {
      throw new ApiError(401, "Unauthorized Access");
    }
    const decodedToken = jwt.verify(accessToken, process.env.ACCESS_TOKEN);

    if (!decodedToken) {
      throw new ApiError(401, "Invalid Token");
    }

    const user = await User.findById(decodedToken?._id).select(
      "-password -refreshToken"
    );

    if (!user) {
      throw new ApiError(401, "unauthorized user");
    }

    req.user = user;
    next();
  } catch (error) {
    throw new ApiError(500, "Error while verifying access token", error);
  }
});

export { verifyJWT };
