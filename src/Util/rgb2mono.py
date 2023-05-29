from PIL import Image

# Open the original image
image = Image.open("./test_RGB_img.png")

# Resize the image to 540 x 540 pixels
resized_image = image.resize((540, 360))

# Convert the image to black and white
bw_image = resized_image.convert("L")

# Save the resulting image as a new file
bw_image.save("test_MONO_img_540x540.png")
