/** \file main.c
 * Just blinks LED using TXEV signal
 */


int main(int argc, char** argv)
{
	int i;

	while(1){
		__sev();
		i = 0x10000;
		while(i--);
	}
}

