#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "xil_printf.h"
#include "xparameters.h"
#include "xil_io.h"
#include "sleep.h"

#include "speech256_axi.h"

#define BASEADDR 	XPAR_SPEECH256_AXI_0_S00_AXI_BASEADDR
#define ADDR_REG 	SPEECH256_AXI_S00_AXI_SLV_REG0_OFFSET
#define STATUS_REG	SPEECH256_AXI_S00_AXI_SLV_REG1_OFFSET

#define NUM_MESSAGES 	3
#define MAX_LENGTH   	30
#define NAME_MAX_LENGTH 100

char message_names[NUM_MESSAGES][NAME_MAX_LENGTH] = {
	"This is a test",
	"Hello",
	"Beam me up"
};

char messages[NUM_MESSAGES][MAX_LENGTH] = {
		{0x1d, 0x0c, 0x37, 0x03, 0x0c, 0x37, 0x03, 0x1A, 0x03, 0x11, 0x07, 0x37, 0x0d, 0xff},
		{27, 45, 53, 255},
		{0x1c, 0x13, 0x10, 0x03, 0x3, 0x10, 0x13, 0x03, 0x03, 0x18, 0x9, 0x03, 0x3, 0x37, 0x08, 0x17, 0x0d, 0x13, 0x3, 0x3, 0xff}
};

char entry[MAX_LENGTH];

struct Allophones_t {
	char id;
	char str[5];
	char ex[10];
};

typedef struct Allophones_t Allophones;

Allophones allophones[65] = {
		{0x00, "PA1", "Pause"},
		{0x01, "PA2", "Pause"},
		{0x02, "PA3", "Pause"},
		{0x03, "PA4", "Pause"},
		{0x04, "PA5", "Pause"},
		{0x05, "OY", "Boy"},
		{0x06, "AY", "Sky"},
		{0x07, "EH", "End"},
		{0x08, "KK3", "Comb"},
		{0x09, "PP", "Pow"},
		{0x0A, "JH", "Dodge"},
		{0x0B, "NN1", "Thin"},
		{0x0C, "IH", "Sit"},
		{0x0D, "TT2", "To"},
		{0x0E, "RR1", "Rural"},
		{0x0F, "AX", "Succeed"},
		{0x10, "MM", "Milk"},
		{0x11, "TT1", "Part"},
		{0x12, "DH1", "They"},
		{0x13, "IY", "See"},
		{0x14, "EY", "Beige"},
		{0x15, "DD1", "Could"},
		{0x16, "UW1", "To"},
		{0x17, "AO", "Aught"},
		{0x18, "AA", "Hot"},
		{0x19, "YY2", "Yes"},
		{0x1A, "AE", "Hat"},
		{0x1B, "HH1", "He"},
		{0x1C, "BB1", "Business"},
		{0x1D, "TH", "Thin"},
		{0x1E, "UH", "Book"},
		{0x1F, "UW2", "Food"},
		{0x20, "AW", "Out"},
		{0x21, "DD2", "Do"},
		{0x22, "GG3", "Wig"},
		{0x23, "VV", "Vest"},
		{0x24, "GG1", "Got"},
		{0x25, "SH", "Ship"},
		{0x26, "ZH", "Azure"},
		{0x27, "RR2", "Brain"},
		{0x28, "FF", "Food"},
		{0x29, "KK2", "Sky"},
		{0x2A, "KK1", "Can't"},
		{0x2B, "ZZ", "Zoo"},
		{0x2C, "NG", "Anchor"},
		{0x2D, "LL", "Lake"},
		{0x2E, "WW", "Wool"},
		{0x2F, "XR", "Repair"},
		{0x30, "WH", "Whig"},
		{0x31, "YY1", "Yes"},
		{0x32, "CH", "Church"},
		{0x33, "ER1", "Letter"},
		{0x34, "ER2", "Fir"},
		{0x35, "OW", "Beau"},
		{0x36, "DH2", "Bath"},
		{0x37, "SS", "Vest"},
		{0x38, "NN2", "No"},
		{0x39, "HH2", "Hoe"},
		{0x3A, "OR", "Store"},
		{0x3B, "AR", "Alarm"},
		{0x3C, "YR", "Clear"},
		{0x3D, "GG2", "Guest"},
		{0x3E, "EL", "Saddle"},
		{0x3F, "BB2", "Business"},
		{0xFF, "END", "END_MSG"}
};

int display_messages()
{
	printf("Would you like to enter your own message or use an existing message?\r\n");
	printf("0 for entering message\r\n");
	for (int i = 0; i < NUM_MESSAGES; i++)
	{
		printf("%d for %s\r\n", i + 1, message_names[i]);
	}

	char input[20], *ptr;


	ptr = input;
	while ((*ptr++ = inbyte()) != '\r')
	{
		printf("%c", *(ptr-1));
		fflush(stdout);
	}
	*ptr = '\0';

	int ret = atoi(input);
	return ret;
}

void print_chars()
{
	for (int i = 0; i < 65; i++)
	{
		printf("%d\t%s\t%s\r\n", allophones[i].id, allophones[i].str, allophones[i].ex);
	}
}

void get_message()
{
	print_chars();
	printf("Max number of entries: %d\r\n", MAX_LENGTH - 1);

	for (int i = 0; i < MAX_LENGTH - 1; i++)
	{
		char input[5], *ptr;

		ptr = input;
		while ((*ptr++ = inbyte()) != '\r')
		{
			printf("%c", *(ptr-1));
			fflush(stdout);
		}
		*ptr = '\0';

		char ret = atoi(input);

		printf(" ");
		fflush(stdout);
		entry[i] = ret;
		if (ret == 0xFF) break;
	}
	printf("\r\n");
	entry[MAX_LENGTH - 1] = 0xFF;
}

int main()
{
	setvbuf(stdin, NULL, _IONBF, 0);
    //init_platform();
	//message_len = sizeof(message)/sizeof(message[0]);

    print("Hello World\n\r");
    //int index = 0;
    while (1)
    {
    	SPEECH256_AXI_mWriteReg(BASEADDR, ADDR_REG, 0);
    	while (SPEECH256_AXI_mReadReg(BASEADDR, STATUS_REG) == 0);

    	int val = display_messages();
    	char *to_send;
    	if (val == 0)
    	{
    		get_message();
    		to_send = entry;
    	}
    	else
    	{
    		to_send = messages[val - 1];
    	}
		for (int i = 0; i < MAX_LENGTH; i++)
		{
			if (to_send[i] == 0xff) break;
			printf("%d ", to_send[i]);
		}
    	printf("\r\n");


    	for (int i = 0; i < MAX_LENGTH; i++)
    	{
    		if (to_send[i] == 0xff) break;
    		SPEECH256_AXI_mWriteReg(BASEADDR, ADDR_REG, to_send[i]);
    		usleep(100);
        	while (SPEECH256_AXI_mReadReg(BASEADDR, STATUS_REG) == 0);
    	}

    	//SPEECH256_AXI_mWriteReg(BASEADDR, ADDR_REG, 0x05);
    	//SPEECH256_AXI_mWriteReg(BASEADDR, ADDR_REG, curr);

    	//while (SPEECH256_AXI_mReadReg(BASEADDR, STATUS_REG) == 0);

    	//index++;
		//if (index == message_len) index = 0;

    }

    //cleanup_platform();
    return 0;
}
