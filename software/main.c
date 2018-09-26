/** \file main.c
 * Just blinks LED using TXEV signal
 */


int main(int argc, char** argv)
{
	int i;

	while(1){
		i = 0x10000;
		while(i--);
		__sev();
	}
}

