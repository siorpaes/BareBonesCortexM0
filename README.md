# BareBonesCortexM0
Extremely basic CortexM0 SoC based on ARM DesignStart Eval.

This simple project aims at creating from scratch a very basic synthesizable Cortex-M0 System on Chip based on  [CortexM0 ARM DesignStart Eval kit](https://developer.arm.com/products/designstart). It is mostly useful for educational purposes such as understanding inner working of the CortexM0 core, understanding how AHB and APB buses work, how to design and implement a bus matrix, etc...

The design can be simulated or implemented on a [Digilent Basys3 board](https://reference.digilentinc.com/basys3/refmanual). Vivado project and constraint files are provided in the 'Basys3' directory.


### Changelog ###
**Tag 0.1**: Simplest possible design based on CortexM0 core interfaced with an AHB Read Only Memory containing a blinky LED project. Blink signal is driven by TXEV which is generated when core executes 'SEV' instruction.
To change the program edit the ROM contents in 'ahb_rom.v' file.

![Blinky Simulation](/images/TXEV.png)

Reset signal is mapped on SW0 switch, TXEV signal is mapped on LD4 led.
