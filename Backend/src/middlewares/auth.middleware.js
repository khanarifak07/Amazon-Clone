import jwt from "jsonwebtoken";
import { User } from "../models/user.model.js";
import { ApiError } from "../utils/ApiError.js";
import { asyncHandler } from "../utils/AsyncHandler.js";

const verifyJWT = asyncHandler(async (req, _, next) => {
  try {
    //get the token from cookies or header
    const token =
      req.cookies?.accessToken ||
      req.header("Authorization").replace("Bearer ", "");
    if (!token) {
      throw new ApiError(401, "Unauthorized Access");
    }
    //verify the token and decode it
    const decodedToken = jwt.verify(token, process.env.ACCESS_TOKEN);
    if (!decodedToken) {
      throw new ApiError(409, "Invalid Token");
    }
    //get the user id from decoded token
    const user = await User.findById(decodedToken?._id);
    if (!user) {
      throw new ApiError(400, "Unauthorized User or User not found");
    }
    //inject user into req.user
    req.user = user;
    //call next middleware
    next();
  } catch (error) {
    throw new ApiError(401, "Error while verifying token ", error);
  }
});

export { verifyJWT };
