#include "stm32f10x.h"
#include "led.h"


void delay(__IO u32 nCount); 

int main(void)
{
    SystemInit();	    // system init, clock=72M 	
    LED_GPIO_Config();  // LED GPIO config 

    while (1) {
        LED1(ON);
        //delay(0x800000);
        delay(0x200000);
        LED1(OFF);
        delay(0x200000);
        //delay(0x800000);
    }
}

void delay(__IO u32 nCount)
{
    for(; nCount != 0; nCount--);
} 

