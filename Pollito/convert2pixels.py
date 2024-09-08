import cv2

img_original = cv2.imread('9Dormido.png') 
img_original = cv2.cvtColor(img_original, cv2.COLOR_BGR2RGB) 

RAM_input_image = []
    
for i in range(0,48): 
    for j in range(0,48):
        pixel = img_original[i][j]
        r, g, b = pixel
        rgb565 = ((r & 0xF8) << 8) | ((g & 0xFC) << 3) | (b >> 3)
        RAM_input_image.append(f'{rgb565:04X}')

with open('9Dormido_48x48.txt', 'w') as f:
    for pixel in RAM_input_image:
        f.write(f"{pixel}\n")