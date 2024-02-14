import express from "express";
import {
  getUserInformation,
  getUserLocation,
  getsoildetails,
  location,
  login,
  logout,
  register,
  soildetails,
} from "../controllers/locationController.js";
import { isAuthenticated } from "../middlewares/auth.js";

const router = express.Router();

router.route("/location").post(location);
router.route("/register").post(register);
router.route("/login").post(login);
router.route("/getuserlocation").get(isAuthenticated, getUserLocation);
router.route("/soildetails").post(isAuthenticated, soildetails);
router.route("/getsoildetails").get(isAuthenticated, getsoildetails);
router.route("/getuserinfo").get(isAuthenticated, getUserInformation);
router.route("/logout").get(logout);

export default router;
