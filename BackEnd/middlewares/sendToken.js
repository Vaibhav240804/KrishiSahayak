export const sendToken = (res, user, message, statusCode = 200) => {
  try {
    const token = user.getJWTToken();
    console.log("\nGenerated Token: " + token);

    const options = {
      maxAge: 15 * 24 * 60 * 60 * 1000, // 15 days in milliseconds
      httpOnly: true,
      sameSite: "none",
      secure: true,
      path: "/", // Specify the path where the cookie is accessible
    };

    res.status(statusCode).cookie("cookie", token, options).json({
      success: true,
      message,
      user,
    });
  } catch (error) {
    console.error("Error setting cookie:", error.message);
    res.status(500).json({ error: "Internal server error" });
  }
};
