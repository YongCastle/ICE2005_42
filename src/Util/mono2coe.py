from PIL import Image

# Open the image
image = Image.open("sobel_output.png")
#image = Image.open("test_MONO_img_540x540.png")

# Resize the image to 540x540 pixels if necessary
if image.size != (540, 540):
    image = image.resize((540, 540))

# Convert the image to grayscale
image = image.convert("L")

# Get the pixel values as a list of integers
pixel_values = list(image.getdata())

# Convert pixel values to hexadecimal format
hex_values = [format(pixel, "02x") for pixel in pixel_values]

# Prepare the COE file content
coe_content = "; Sample memory initialization file for Single Port Block Memory,\n"
coe_content += "; v3.0 or later.\n"
coe_content += ";\n"
coe_content += "; This .COE file specifies initialization values for a block\n"
coe_content += f"; memory of depth={len(hex_values)}, and width=8. In this case, values\n"
coe_content += "; are specified in hexadecimal format.\n"
coe_content += "memory_initialization_radix=16;\n"
coe_content += "memory_initialization_vector=\n"

# Split hex values into separate lines for memory initialization
coe_content += ",\n".join(hex_values)

# Add a semicolon to the last line
coe_content += ";"

# Save the COE file
with open("test_MONO_img_540x540.coe", "w") as f:
    f.write(coe_content)
