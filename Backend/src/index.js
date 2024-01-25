import dotenv from "dotenv";
import { connectDB } from "./db/dbConnect.js";
dotenv.config({ path: ".env" });
import {app} from './app.js'

connectDB()
  .then(() => {
    app.on("error", () => {
      console.log("Error while connecting to DataBase");
    });

    app.listen(process.env.PORT || 8000, () => {
      console.log(`Server is running at port ${process.env.PORT}`);
    });
  })
  .catch((error) => {
    console.log("Something went wrong while connecting to Database", error);
  });
