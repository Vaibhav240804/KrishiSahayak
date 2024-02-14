import jwt from "jsonwebtoken";
import { User } from "../models/User.js";
import { catchAsyncError } from "./catchAsyncErrors.js";
import ErrorHandler from "./errorHandler.js";

export const isAuthenticated = catchAsyncError(async (req, res, next) => {
  const { token } = req.cookies;

  console.log("jwttoken : " + token);
  if (!token) {
    return next(new ErrorHandler("Unauthorized", 401));
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    console.log("\n" + decoded);
    req.user = await User.findById(decoded.userId);
    // console.log(req.user);
    next();
  } catch (error) {
    return next(new ErrorHandler("Unauthorized", 401));
  }
});
