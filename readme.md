Lab4- PicoBalze and MicroBlaze
=========

C2C John Miller

VHDL Code to interface picoblaze and microblaze with teraterm.
If the code "SWT" is typed into the terminal, it returns the current hex value of the switch. 
If "LED" is typed, it then accepts a 2 digit hex value and then lights up the corresponding LEDS.


The major problems that this project dealt with were:
* Properly instantiating picoblaze and microblaze.
* Creating a UART module (picoblaze)
* Discerning how to get the picoblaze and microblaze code to interface with external inputs and outputs.



Version
----

1.0 - Interfaces the processors with the terminal


Works in Progress
----
* 1.1 - Control a vga monitor with the "VGA" command.

Implementation
-----------
This was much more a problem of properly reading datasheets than a problem of state machines, as the problem itself was very simple. 
The major steps for both picoblaze and microblaze were done in this order:
* Get the processors to echo through the terminal
* Get the terminal to recognize a 3 input command and then new line carriage return.
* Have the terminal recognize when a specific command was input (SWT vs LED)
* Get switch funcitonality
* Get led functionality


The following basic constructs were used to realize the font controller:

Clk_to_baud (synchronization element):

```Vhdl
  baud_rate: process(clk, reset)
    	begin
			if(reset = '1') then
				baud_count<=0;
			elsif rising_edge(clk) then
				if baud_count = N then
					baud_count <= 0;
					en_16_x_baud <= '1';
				else
					baud_count <= baud_count + 1;
					en_16_x_baud <= '0';
				end if;
			end if;
	end process baud_rate;

```
nibble to ascii (convert 4 bit hex to its ascii equivalent)

```Vhdl
case Nibble is
    
		when x"0" => Ascii <= x"30" ;
		when x"1" => Ascii <= x"31" ;
		when x"2" => Ascii <= x"32" ; 
		when x"3" => Ascii <= x"33" ;
		when x"4" => Ascii <= x"34" ;
		when x"5" => Ascii <= x"35" ;
		when x"6" => Ascii <= x"36" ;
		when x"7" => Ascii <= x"37" ;
		when x"8" => Ascii <= x"38" ;
		when x"9" => Ascii <= x"39" ;
		when x"A" => Ascii <= x"41" ;
		when x"B" => Ascii <= x"42" ;
		when x"C" => Ascii <= x"43" ;
		when x"D" => Ascii <= x"44" ;
		when x"E" => Ascii <= x"45" ;
		when x"F" => Ascii <= x"46" ;
		when others => Ascii <= x"00" ;

	end case;

```
Ascii to nibble (converts 8 bit ascii to its 4 bit equivalent)

```Vhdl
case ascii is
    
		when x"30" => nibble <= x"0" ;
		when x"31" => nibble <= x"1" ;
		when x"32" => nibble <= x"2" ; 
		when x"33" => nibble <= x"3" ;
		when x"34" => nibble <= x"4" ;
		when x"35" => nibble <= x"5" ;
		when x"36" => nibble <= x"6" ;
		when x"37" => nibble <= x"7" ;
		when x"38" => nibble <= x"8" ;
		when x"39" => nibble <= x"9" ;
		when x"41" => nibble <= x"A" ;
		when x"42" => nibble <= x"B" ;
		when x"43" => nibble <= x"C" ;
		when x"44" => nibble <= x"D" ;
		when x"45" => nibble <= x"E" ;
		when x"46" => nibble <= x"F" ;
		when others => nibble <= x"0" ;

	end case;

```

The following modules were to implement the processors
* clk_to_baud.vhd - Generate an appropriate baud rate
* uart_rxt.vhd - uart module
* vga_sync.vhd - Synchronizes the h_sync and v_sync signals to specify a specific pixel 
* nibble_to_ascii.vhd - Creates an ascii character based on a hex number.
* acii_to_nibble.vhd - Generates a hex number based on an ascii character.
* processor.vhd - The picoblaze processor
* top.vhd - Top-shell module



The modules for a functionality are connected as shown below:


![block diagram](block_diagram.jpg)


Troubleshooting
--------------

PicoBlaze:
The biggest troubles I had came from getting the UART module to correctly echo, once that worked, then the rest went along normally. Other than that, there were no major hang ups. 

MicroBlaze:
For some reason, I could not get my switches to read in correctly, then I realized that I was using a += command on a variable that did not have any data, so it wasn't actually doing anthing.



Lessons Learned
---

* Learn more about how picoblaze and microblaze work, they will probably show up later.
* If everything looks right and nothing works, have someone else look at your code, and walk through your functionality, you will catch minor errors that you wouldn't have.


##### TODO


* VGA functionality
* Magic numbers, how do they work?

Documentation
----

None