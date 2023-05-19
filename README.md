# Sobel Filter Implementation in Verilog

This project is a Sobel filter implementation in Verilog, targeting the Vivado 2020.2 development environment. The implementation has been verified on libertron's FPGA Starter Kit Ⅲ.

## Features

The Sobel filter is implemented using the following modules and components:
- Block RAM (BRAM): Used for storing the image data.
- 7-Segment Display: Displays relevant information or results.
- LED: Provides visual indicators or status feedback.
- Buzzer: Generates audio signals for notifications or alerts.
- VGA: Displays the original image and the Sobel filtered image.

## Image and Operation Details

The project uses a 540x540 black and white road image as the input. The Sobel filter operation is applied to this image, generating an output image that highlights the edges and gradients within the original image.

## Final Term Project Assignment

This project was performed as a final term project assignment for Sungkyunkwan University's logic circuit design experiment term project assignment.

## Getting Started

To use this project, follow these steps:
1. Set up the Vivado 2020.2 development environment.
2. Create a new project and specify the target FPGA device.
3. Import the Verilog source files provided in this repository.
4. Connect the modules and components as per the design requirements.
5. Generate the bitstream and program it onto the FPGA board.
6. Ensure the necessary input image is loaded into the BRAM.
7. Power on the FPGA board and observe the results on the VGA display.

Please refer to the accompanying documentation and design files for further details on the project setup, module interfaces, and usage instructions.
