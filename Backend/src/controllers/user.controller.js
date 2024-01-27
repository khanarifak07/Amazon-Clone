import { User } from "../models/user.model.js";
import { ApiError } from "../utils/ApiError.js";
import { ApiResponse } from "../utils/ApiResponse.js";
import { asyncHandler } from "../utils/AsyncHandler.js";

const registerUser = asyncHandler(async (req, res) => {
  //get the data from the user (req.body)
  //check username or email is already  registered
  //create user in databse .create
  //return response
  const { username, email, password } = req.body;
  if ([username, email, password].some((fields) => fields.trim() === "")) {
    throw new ApiError(400, "Add details are required");
  }

  const existingUser = await User.findOne({ $or: [{ username }, { email }] });
  if (existingUser) {
    throw new ApiError(
      400,
      "User is already registered with this email or username"
    );
  }

  const user = await User.create({
    username,
    email,
    password,
  });
  if (!user) {
    throw new ApiError(500, "Something went wrong while creating user");
  }

  const createdUser = await User.findById(user._id).select("-password");

  return res
    .status(200)
    .json(new ApiResponse(200, createdUser, "User registered successfully"));
});

const generateAccessAndRefreshToken = async function (userId) {
  try {
    const user = await User.findById(userId);
    const accessToken = await user.generateAccessToken();
    const refreshToken = await user.generateRefreshToken();
    user.refreshToken = refreshToken;
    await user.save({ validateBeforeSave: false });
    return { accessToken, refreshToken };
  } catch (error) {
    console.log(
      "Something went wrong while generating access and refrehs token"
    );
  }
};

const loginUser = asyncHandler(async (req, res) => {
  //take the inout form user req.body
  //chec user is registered or not
  //check password
  //generate access and refresh token
  //set option to send in cookies
  //return response

  const { email, username, password } = req.body;

  if (!(email || password)) {
    throw new ApiError(400, "Email and password is required");
  }

  const user = await User.findOne({ $or: [{ username }, { email }] });

  if (!user) {
    throw new ApiError(400, "User not registered or not found");
  }

  const isPassMatch = await user.isPasswordCorrect(password);
  console.log("isPasswordMatch", isPassMatch);
  if (!isPassMatch) {
    throw new ApiError(400, "Invalid Password");
  }

  const { refreshToken, accessToken } = await generateAccessAndRefreshToken(
    user._id
  );

  const loggedInUser = await User.findById(user._id).select(
    "-password -refreshToken"
  );

  const options = {
    httpOnly: true,
    secure: true,
  };

  return res
    .status(200)
    .cookie("accessToken", accessToken, options)
    .cookie("refreshToken", refreshToken, options)
    .json(new ApiResponse(200, loggedInUser, "User logged In Successfully"));
});

const logoutUser = asyncHandler(async (req, res) => {
  //Only loggedIn user can logout so I need to verify user from the access token need to create verifyJWT middleware
  //find the user by id  and update and remove the refresh token field
  //set the oprions to clear the cookies
  await User.findByIdAndUpdate(
    req.user?._id,
    {
      $unset: {
        refreshToken: 1, //unset remove the refreshToken field
      },
    },
    {
      new: true,
    }
  );

  const options = {
    httpOnly: true,
    secure: true,
  };

  return res
    .status(200)
    .clearCookie("accessToken", options)
    .clearCookie("refreshToken", options)
    .json(new ApiResponse(200, {}, "User logged out successfully"));
});

const getCurrentUser = asyncHandler(async (req, res) => {
  console.log(`Current User fetched ${req.user}`);
  return res
    .status(200)
    .json(new ApiResponse(200, req.user, "Current User Fetched Successfully"));
});

export { getCurrentUser, loginUser, logoutUser, registerUser };
