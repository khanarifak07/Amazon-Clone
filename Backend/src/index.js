import express from "express";
const app = express();

app.get("/", (req, res) => {
  res.send("Hello Arif");
  console.log("Server is running");
});

app.listen(8000, () => {
  console.log("Server started on port 8000");
});
