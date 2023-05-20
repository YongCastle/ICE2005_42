import cv2

# Load the image
image = cv2.imread("test_MONO_img_540x540.png", cv2.IMREAD_GRAYSCALE)

# Apply the Sobel operator
sobelx = cv2.Sobel(image, cv2.CV_64F, 1, 0, ksize=3)
sobely = cv2.Sobel(image, cv2.CV_64F, 0, 1, ksize=3)
sobel = cv2.addWeighted(sobelx, 0.5, sobely, 0.5, 0)

# Save the processed image
cv2.imwrite("sobel_output.png", sobel)

print("Sobel operator applied and the processed image is saved as sobel_output.png.")
