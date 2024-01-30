import cookieParser from "cookie-parser";
import cors from "cors";
import express from "express";
const app = express();

//cors configuratin as middleware (cross origin resourse sharing)
app.use(
  cors({
    origin: "*",
    credentials: true,
  })
);

//configuration for json (receives data from json)
app.use(
  express.json({
    limit: "16kb",
  })
);

//configuration for url encoded via express (receives data from url)
app.use(
  express.urlencoded({
    extended: true,
    limit: "16kb",
  })
);

//configration for asset via express e.g pdf, jpg, png
app.use(express.static("public"));

//configuration for cookies
app.use(cookieParser());

//import router
import productRouter from "./routes/product.routes.js";
import userRouter from "./routes/user.routes.js";

app.use("/api/v1/user", userRouter);
app.use("/api/v1/product", productRouter);

export { app };
