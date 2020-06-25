# speech_zybo
Digital voice synthesizer on Xilinx Zynq FPGA  based off the [Speech256](https://github.com/trcwm/Speech256) project by trcwm.

## Demo Video
**TODO**

## Implementation
Speech256 was implemented on the FPGA, with additional verilog code to get the correct clock rates and to create an AXI-lite peripheral to control the voice synthesis

Software running on the ARM processor on the Zynq can issues addresses to the programmable logic to commence playing specific allophones. Either preloaded messages can be played, or a list of allophones can be provided and the user enters the desired sounds.

**TODO Image of block diagram**

## Required Hardware 
[Zybo Z7-20](https://store.digilentinc.com/zybo-z7-zynq-7000-arm-fpga-soc-development-board/), but should be easy to adapt to any Zynq board

The output from the FPGA is a PWM signal that needs to be filtered. Create a low pass filter with a 1200Ω resistor and 0.1uF capacitor. Another capacitor can be used as a DC blocking cap before connecting to an audio device. I used a audio jack to connect the output to a boombox. 

The input of the LPF should be connected to JD - pin 2 on the FPGA. Make sure to connect ground as well!

**TODO Add picture**

## Required Software
Developed on Xilinx Vivado and Vitis 2019.2 on Linux. Build scripts not tested on Windows

## Running the Project
### Programmable Logic
1. In the tcl console in Vivado, navigate to the repository (`cd path/to/cloned/repo`) and run `source build.tcl`. This will create the project.
2. Click "Generate Bitstream" to compile the project and create a bitstream.
3. Simulations can be performed by clicking "Run Simulation" in the Flow Navigator.

### Programmable Software
**TODO Automate with tcl**

1. In Vivado, click "File->Export->Export Hardware". Choose a place to save it, and be sure to check the box labeled "Include bistream"
2. Click "Tools->Launch Vitis"
3. Create a workspace named "vitis_ws" inside the top level of the repo
4. Create a platform project
   1. "File->New->Platform Project".
   2. Give it a name: "speech_platform"
   3. Select "Create from hardware specification (XSA).
   4. Select the exported XSA file from step 1, set the Operating System to "stadalone" and Processor to "ps7_cortexa9_0"
5. If you plan to use the emulated console in Vitis, you must change stdin and stdout by following the instructions below. Otherwise, to use a standard serial port leave this unchanged.
    1. Under speech_platform in the Explorer, "open platform.spr"
    2. Click on "Board Support Package" under "standalone on ps7_cortexa9_0", then click "Modify BSP Settings"
    3. Under "Overview->standalone" change the value of stdin and stdout from "ps7_uart_1" to "ps7_coresight_comp_0"
6. Create an application project.
    1. "File->New->Application Project"
    2. Give it a name "speech_app". Make sure "Create New..." is selected under "System project"
    3. Select "speech_platform" you created
    4. Select standalone_domain and C language
    5. Select Empty APplication template
7. Add `ps_src/speech_with_entry.c` to src/speech_app
    1. Right click on speech_app_system/speech_app/src and select Import Sources
    2. Browse to and select the speech_with_entry.c file and click Finish
8. Right click on speech_app and click build.
9. Plug in your board and turn it on
10. Right click on speech_app, select "Debug as->Launch on Hardware". This opens the debugging panes of Vitis.
11. Connect to the serial Port
    1. If you are using the virtual console in Vitis, on the bottom select "Console". If it says it is connected to Core #1, change this to core 0 under the drop down next to the Display icon.
    2. If you are using a normal serial port, connect to the serial port with the baud rate 115200
12. On the top of Vitis click the green triangle button (Resume) or press F8
13. Congrats! The speech synthesizer is now running! Select the preloaded messages or try your own.
