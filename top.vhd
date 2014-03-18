----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:38:25 03/11/2014 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is

	port(
		   clk        : in  std_logic;
         reset      : in  std_logic;
         serial_in  : in  std_logic;
			button     : in  std_logic_vector(3 downto 0);
         serial_out : out std_logic;
         switch     : in  std_logic_vector(7 downto 0);
         led        : out std_logic_vector(7 downto 0)
		);
end top;

architecture Behavioral of top is

component kcpsm6 
  generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                  interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
           scratch_pad_memory_size : integer := 64);
  port (                   address : out std_logic_vector(11 downto 0);
                       instruction : in std_logic_vector(17 downto 0);
                       bram_enable : out std_logic;
                           in_port : in std_logic_vector(7 downto 0);
                          out_port : out std_logic_vector(7 downto 0);
                           port_id : out std_logic_vector(7 downto 0);
                      write_strobe : out std_logic;
                    k_write_strobe : out std_logic;
                       read_strobe : out std_logic;
                         interrupt : in std_logic;
                     interrupt_ack : out std_logic;
                             sleep : in std_logic;
                             reset : in std_logic;
                               clk : in std_logic);
  end component;
  
  
  component lab_4a_rom                      
    generic(             C_FAMILY : string := "S6"; 
                C_RAM_SIZE_KWORDS : integer := 1;
             C_JTAG_LOADER_ENABLE : integer := 0);
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    rdl : out std_logic;                    
                    clk : in std_logic);
  end component;
  
  	COMPONENT clk_to_baud
	generic ( N: integer );
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		baud_16x_en : OUT std_logic
		);
	END COMPONENT;
  
  COMPONENT uart_rx6
	PORT(
		serial_in : IN std_logic;
		en_16_x_baud : IN std_logic;
		buffer_read : IN std_logic;
		buffer_reset : IN std_logic;
		clk : IN std_logic;          
		data_out : OUT std_logic_vector(7 downto 0);
		buffer_data_present : OUT std_logic;
		buffer_half_full : OUT std_logic;
		buffer_full : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT uart_tx6
	PORT(
		data_in : IN std_logic_vector(7 downto 0);
		en_16_x_baud : IN std_logic;
		buffer_write : IN std_logic;
		buffer_reset : IN std_logic;
		clk : IN std_logic;          
		serial_out : OUT std_logic;
		buffer_data_present : OUT std_logic;
		buffer_half_full : OUT std_logic;
		buffer_full : OUT std_logic
		);
	END COMPONENT;

	COMPONENT nibble_to_ascii
	PORT(
		nibble : IN std_logic_vector(3 downto 0);          
		ascii : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
	COMPONENT ascii_to_nibble
	PORT(
		ascii : IN std_logic_vector(7 downto 0);          
		nibble : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
-- Signals for connection of KCPSM6 and Program Memory.
--

signal         address : std_logic_vector(11 downto 0);
signal     instruction : std_logic_vector(17 downto 0);
signal     bram_enable : std_logic;
signal         in_port : std_logic_vector(7 downto 0);
signal        out_port : std_logic_vector(7 downto 0);
signal         port_id : std_logic_vector(7 downto 0);
signal    write_strobe : std_logic;
signal  k_write_strobe : std_logic;
signal     read_strobe : std_logic;
signal       interrupt : std_logic;
signal   interrupt_ack : std_logic;
signal    kcpsm6_sleep : std_logic;
signal    kcpsm6_reset : std_logic;

--
-- Some additional signals are required if your system also needs to reset KCPSM6. 
--

signal       cpu_reset : std_logic;
signal             rdl : std_logic;

--
-- When interrupt is to be used then the recommended circuit included below requires 
-- the following signal to represent the request made from your system.
--

signal     int_request : std_logic;
signal     baud_out : std_logic;

-- Signals used to connect UART_TX6
--
signal      uart_tx_data_in : std_logic_vector(7 downto 0);
signal     write_to_uart_tx : std_logic;
signal uart_tx_data_present : std_logic;
signal    uart_tx_half_full : std_logic;
signal         uart_tx_full : std_logic;
signal         uart_tx_reset : std_logic;
--
-- Signals used to connect UART_RX6
--
signal     uart_rx_data_out : std_logic_vector(7 downto 0);
signal    read_from_uart_rx : std_logic;
signal uart_rx_data_present : std_logic;
signal uart_rx_data_present_intermediate : std_logic;

signal    uart_rx_half_full : std_logic;
signal         uart_rx_full : std_logic;
signal        uart_rx_reset : std_logic;

signal         en_16_x_baud : std_logic ;
signal 			switch_char_hi : std_logic_vector(7 downto 0);
signal 			switch_char_lo : std_logic_vector(7 downto 0);

begin

	baud_signal: clk_to_baud 
	generic map ( N => 651)
	PORT MAP(
		clk => clk,
		reset => reset,
		baud_16x_en => en_16_x_baud
	);

  rx: uart_rx6 
  port map (            serial_in => serial_in,
                     en_16_x_baud => en_16_x_baud,
                         data_out => uart_rx_data_out,
                      buffer_read => uart_rx_data_present,
              buffer_data_present => uart_rx_data_present_intermediate,
                 buffer_half_full => open,
                      buffer_full => open,
                     buffer_reset => '0',              
                              clk => clk);

  tx: uart_tx6 
  port map (              data_in => uart_tx_data_in,
                     en_16_x_baud => en_16_x_baud,
                       serial_out => serial_out,
                     buffer_write => uart_tx_data_present,
              buffer_data_present => open,
                 buffer_half_full => open,
                      buffer_full => open,
                     buffer_reset => '0',              
                              clk => clk);
	
			uart_rx_data_present <= '1' when port_id = X"02" and read_strobe = '1'
									 else '0';

			uart_tx_data_present <= '1' when port_id = X"03" and write_strobe = '1'
									 else '0';

			--input to kcpsm6
			in_port <= uart_rx_data_out when port_id = x"02" else
									"0000000" & uart_rx_data_present_intermediate when port_id =x"01" else
									(others => '0');

			--input to uart_tx6	
			uart_tx_data_in <= out_port when port_id = x"03" else
								(others => '0');
							







  processor: kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);
 
 

	

						
 
 

	program_rom: lab_4a_Rom                  --Name to match your PSM file
	generic map(             C_FAMILY => "S6",   --Family 'S6', 'V6' or '7S'
                   C_RAM_SIZE_KWORDS => 1,      --Program size '1', '2' or '4'
                 C_JTAG_LOADER_ENABLE => 1)      --Include JTAG Loader when set to '1' 
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       rdl => kcpsm6_reset,
                       clk => clk);


	
		niblle_ascii_hi: nibble_to_ascii PORT MAP(
		nibble => in_port(7 downto 4),
		ascii =>  switch_char_hi	
	);
		
		nibble_ascii_lo: nibble_to_ascii PORT MAP(
		nibble => in_port(3 downto 0),
		ascii =>  switch_char_lo	
	);	
	
	

	
	

  --
  -- In many designs (especially your first) interrupt and sleep are not used.
  -- Tie these inputs Low until you need them. Tying 'interrupt' to 'interrupt_ack' 
  -- preserves both signals for future use and avoids a warning message.
  -- 

  kcpsm6_sleep <= '0';
  interrupt <= interrupt_ack;


end Behavioral;

