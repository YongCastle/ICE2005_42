from PIL import Image

# Read the COE file
with open("test_MONO_img_540x360.coe", "r") as f:
    coe_content = f.read()

# Remove the header and split the hex values
hex_values = coe_content.split("=")[-1].split(";")[0].replace("\n", "").split(",")

# Convert hex values to integers
pixel_values = [int(hex_value, 16) for hex_value in hex_values]

# Create a new image with the desired size
image = Image.new("L", (540, 360))

# Set the pixel values in the image
image.putdata(pixel_values)

# Save the MONO image
image.save("reconstructed_MONO_image.png")
