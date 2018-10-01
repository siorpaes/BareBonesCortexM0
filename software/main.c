/** \file main.c
 * Just blinks LED using TXEV signal
 * Writes data into a peripheral @ 0x50000008
 */

#include <stdint.h>

int main(int argc, char** argv)
{
	int i;
	unsigned int data = 0;
	int span = 'z' - 'A';

	while(1){
		__sev();
		*((uint32_t*)0x50000008) = 'A' + (data++ % span);

		i = 0x10000;
		while(i--);
	}
}

