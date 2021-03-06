#include <xparameters.h>
#include <xgpio.h>
#include <xstatus.h>
#include <xil_printf.h>

//Definitions
#define GPIO_DEVICE_ID_LEDS XPAR_LED_DEVICE_ID //device IDs
#define GPIO_DEVICE_ID_SWB XPAR_SWB_DEVICE_ID //swb device ids
#define WAIT_VAL 10000000 //100 MHz clock input
#define false 0 //for boolean variables and better readability
#define true 1

int delay(void) { //slows the 100 MHz clock down to 1 MHz
	volatile int delay_count = 0;
	while (delay_count < WAIT_VAL) {
		delay_count++;
	}
	return (0);
}

int main() {
	int count = 0; //count
	int count_masked = 0; //count in hex
	XGpio leds; //LEDs
	XGpio swb; //switches-buttons
	int status;

	status = XGpio_Initialize(&leds, GPIO_DEVICE_ID_LEDS);
	XGpio_SetDataDirection(&leds, 1, 0); //0 is for output
	if (status != XST_SUCCESS) {
		xil_printf("Initialization failed (LEDs)");
	}

	XGpio_Initialize(&swb, GPIO_DEVICE_ID_SWB);
	XGpio_SetDataDirection(&swb, 1, 1);//1 is for input
	int switchValue = 0;

	//how we know if things change
	_Bool b0 = false;
	_Bool b1 = false;
	_Bool b2 = false;
	_Bool b3 = false;

	for (;;) { //this loop will go until the user terminates the program manually
		_Bool btn0 = ((XGpio_DiscreteRead(&swb, 1) & 0x01) == 0x01);//button 0 pressed
		_Bool btn1 = ((XGpio_DiscreteRead(&swb, 1) & 0x02) == 0x02);//button 1 pressed
		_Bool btn2 = ((XGpio_DiscreteRead(&swb, 1) & 0x04) == 0x04); //button 2 pressed
		_Bool btn3 = ((XGpio_DiscreteRead(&swb, 1) & 0x08) == 0x08); //button 3 pressed

		if (!btn2 && !btn3) XGpio_DiscreteWrite(&leds, 1, 0); //turn off leds

		if (btn0) {
			//This checks if other buttons are pressed and will print out those changes
			if (b1) { b1 = false; xil_printf("Button[1] has been released!\n"); }
			if (b2) { b2 = false; xil_printf("Button[2] has been released!\n"); }
			if (b3) { b3 = false; xil_printf("Button[3] has been released!\n"); }
			if (!b0) { xil_printf("Button[0] has been pressed!\n\r"); b0 = true; }

			count++; //adds 1 to counter per tick
			count_masked = count & 0xF; //turns count into hex
			xil_printf("Value of LEDs = 0x%x\n\r", count_masked); //value of LEDS are printed out in hex
			delay(); //delay of 1MHz
		}
		else if (btn1) {
			//checker
			if (b0) { b0 = false; xil_printf("Button[0] has been released!\n\r"); }
			if (b2) { b2 = false; xil_printf("Button[2] has been released!\n\r");  }
			if (b3) { b3 = false; xil_printf("Button[3] has been released!\n\r");  }
			if (!b1) { b1 = true; xil_printf("Button[1] has been pressed!\n\r"); }

			count--; //subtracts 1 from count
			count_masked = count & 0xF; //turns count into hex
			xil_printf("Value of LEDs = 0x%x\n\r", count_masked); //values of LEDS are printed in hex
			delay(); //delay
		}

		else if (btn2) {
			//checker
			if (b1) { b1 = false; xil_printf("Button[1] has been released!\n\r"); }
			if (b0) { b0 = false; xil_printf("Button[0] has been released!\n\r"); }
			if (b3) { b3 = false; xil_printf("Button[3] has been released!\n\r");}
			if (!b2) { b2 = true; xil_printf("Button[2] has been pressed!\n\r"); }

			//print switches into LEDs
			if ((XGpio_DiscreteRead(&swb, 1) & 0xF0) != switchValue) {
				switchValue = XGpio_DiscreteRead(&swb, 1) & 0xF0;
				xil_printf("You moved a switch! Switch Value: %d\n\r", switchValue >> 4);
			}
			XGpio_DiscreteWrite(&leds, 1, switchValue >> 4);

		}
		else if (btn3) {
			//same checker
			if (b1) { b1 = false; xil_printf("Button[1] has been released!\n\r"); }
			if (b0) { b0 = false; xil_printf("Button[0] has been released!\n\r"); }
			if (b2) { b2 = false; xil_printf("Button[2] has been released!\n\r");}
			if (!b3) { b3 = true; xil_printf("Button[3] has been pressed!\n\r"); }
			//prints count into LEDs
			XGpio_DiscreteWrite(&leds, 1, count_masked);
		}
	}
}
