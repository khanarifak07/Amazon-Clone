import { v2 as cloudinary } from "cloudinary";
import fs from "fs";

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_KEY_SECRET,
});

const uploadFileOnCloudinary = async (localFilePath) => {
  try {
    if (!localFilePath) return null;
    
    // Upload to cloudinary
    const response = await cloudinary.uploader.upload(localFilePath, {
      resource_type: "auto",
    });

    console.log("File uploaded successfully on Cloudinary", response.url);

    // Check if the file exists before attempting to unlink
    if (fs.existsSync(localFilePath)) {
      // Unlink file after successful upload
      fs.unlinkSync(localFilePath);
      console.log("Deleted local file:", localFilePath);
    } else {
      console.warn("Local file not found:", localFilePath);
    }

    return response;
  } catch (error) {
    console.error("Error uploading file to Cloudinary", error);

    // Check if the file exists before attempting to unlink
    if (fs.existsSync(localFilePath)) {
      // Unlink file after failure
      fs.unlinkSync(localFilePath);
      console.log("Deleted local file after failure:", localFilePath);
    } else {
      console.warn("Local file not found after failure:", localFilePath);
    }

    return null;
  }
};

export { uploadFileOnCloudinary };


/* import { v2 as cloudinary } from "cloudinary";
import fs from "fs";

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_KEY_SECRET,
});

const uploadFileOnCloudinary = async (localFilePath) => {
  try {
    if (!localFilePath) return null;
    //upload to cloudinary
    const response = await cloudinary.uploader.upload(localFilePath, {
      resource_type: "auto",
    });
    console.log("File uploaded successfully on cloudinary", response.url);
    //unlink file after successfull upload
    fs.unlinkSync(localFilePath);
    return response;
  } catch (error) {
    //unlink file after failure
    fs.unlinkSync(localFilePath);
    return null;
  }
};

export { uploadFileOnCloudinary };  */

//Package.json
// The -r dotenv/config flag is used to include the dotenv configuration before running your application,
// allowing you to load environment variables from a .env file.
// The --experimental-json-modules flag enables support for ECMAScript modules (ESM) when importing JSON files.
