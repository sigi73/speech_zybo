#include <stdio.h>
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_io.h"
#include "sleep.h"

#include "speech256_axi.h"

#define BASEADDR 	XPAR_SPEECH256_AXI_0_S00_AXI_BASEADDR
#define ADDR_REG 	SPEECH256_AXI_S00_AXI_SLV_REG0_OFFSET
#define STATUS_REG	SPEECH256_AXI_S00_AXI_SLV_REG1_OFFSET

char message[] = {0x1d, 0x0c, 0x37, 0x03, 0x0c, 0x37, 0x03, 0x1A, 0x03, 0x11, 0x07, 0x37, 0x0d, 0xff};
int message_len;

int main()
{
    //init_platform();
	message_len = sizeof(message)/sizeof(message[0]);

    print("Hello World\n\r");
    int index = 0;
    while (1)
    {
    	char curr = message[index];
    	//SPEECH256_AXI_mWriteReg(BASEADDR, ADDR_REG, 0x05);
    	SPEECH256_AXI_mWriteReg(BASEADDR, ADDR_REG, curr);
    	printf("Submitted\r\n");

    	usleep(100);
    	while (SPEECH256_AXI_mReadReg(BASEADDR, STATUS_REG) == 0);

    	printf("Completed\r\n");

    	index++;
		if (index == message_len) index = 0;

    }

    //cleanup_platform();
    return 0;
}
