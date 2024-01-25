import dotenv from "dotenv";
dotenv.config({ path: ".env" });
import express from "express";
const app = express();

app.get("/", (req, res) => {
  res.send("Hello Arif");
  console.log("Server is running");
});

app.listen(process.env.PORT || 8000, () => {
  console.log(`Server is running on port ${process.env.PORT}`);
});
