# Entrega 1 del proyecto WP01
* Stewart Andres Antolinez Zapata
* Natalia Andrea Dueñas Salamanca
* Juan Diego Sáenz Ardila
## Especificación detallada del sistema 
### Componentes
Botones
* Reset: Reestablece el Tamagotchi a un estado inicial conocido al mantener pulsado el botón durante al menos 5 segundos. Este estado inicial simula el despertar de la mascota con salud óptima. Botón de la tarjeta de desarrollo de la FPGA.

* Test: Activa el modo de prueba al mantener pulsado por al menos 5 segundos, permitiendo al usuario navegar entre los diferentes estados del Tamagotchi con cada pulsación. Boton de la tarjeta de desarrollo de la FPGA.

* Dar_comer: Disminuye un porcentaje del tiempo a los estados al pulsarse. Botón de la tarjeta de desarrollo de la FPGA.

* Medicina: Disminuye un porcentaje del tiempo a los estados al pulsarse. Botón de la tarjeta de desarrollo de la FPGA.


![Botones tarjeta de desarrollo FPGA](<Imagenes/Botones FPGA.png>)

Sensores
* Sensor Ultra sonido: cuando este sensor detecte algo menor a una distancia determinada disminuye el tiempo sin cariño el cual afecta el estado Animo si el Tamagotchi se encuentra despierto y si esta dormido se despierta. Sensor Ultrasonido HC-SR04.

![[Link](https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.puntoflotante.net%2FSENSOR-DISTANCIA-PROXIMIDAD-ULTRASONICO-HC-SR04.htm&psig=AOvVaw3XawL_13PjA-c5dnOsjxe6&ust=1713975300415000&source=images&cd=vfe&opi=89978449&ved=0CBUQ3YkBahcKEwi447_b3diFAxUAAAAAHQAAAAAQEQ)](Imagenes/Working-of-HC-SR04-Ultrasonic-Sensor-1024x394.jpg)

![[link](https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.qbprofe.com%2Fautomatizacion-instrumentacion-industrial%2Ftutorial-de-arduino-con-sensor-ultrasonico-hc-sr04%2F&psig=AOvVaw3XawL_13PjA-c5dnOsjxe6&ust=1713975300415000&source=images&cd=vfe&opi=89978449&ved=0CBUQ3YkBahcKEwi447_b3diFAxUAAAAAHQAAAAAQIQ)](Imagenes/ww-PINES.jpg)


Visualización

 <!-- Pantalla LCD: Esencial para representar visualmente el estado actual del Tamagotchi, incluyendo emociones y necesidades básicas, ademas, es utilizado para mostrar niveles y puntuaciones específicas, como el nivel de Animo, Sueño, Salud y Energía, complementando la visualización principal, separando los espacios de la pantalla para destinarlo a la visualización del Tamagotchi y otra para los puntajes. Display Pantalla Lcd TFT 2.2 Pulgadas 240×320 SPI ILI9341 5V/3.3V. * -->

* Matriz LEDs 8x8: 



* Displays 7 segmentos: Permite 

