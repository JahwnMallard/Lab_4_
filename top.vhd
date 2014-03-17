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
	generic ( N: integer := 325 );
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
signal    uart_rx_half_full : std_logic;
signal         uart_rx_full : std_logic;
signal        uart_rx_reset : std_logic;

signal         en_16_x_baud : std_logic := '0';

begin
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
 
 
input_ports: process(clk)
  begin
    if rising_edge(clk) then

      case port_id is

        -- Read input_port_a at port address AF hex
        when x"AF" =>    in_port(3 downto 0) <= Switch(3 downto 0);

        -- Read input_port_b at port address 01 hex
         when x"07" =>   in_port(7 downto 4) <= button;


        when others =>    in_port <= (others => '0');  

      end case;

    end if;

		 if (read_strobe = '1') and (port_id(1 downto 0) = "01") then
			  read_from_uart_rx <= '1';
			 else
			  read_from_uart_rx <= '0';
		 end if;



  end process input_ports;
 

  program_rom: lab_4a_Rom                  --Name to match your PSM file
    generic map(             C_FAMILY => "S6",   --Family 'S6', 'V6' or '7S'
                    C_RAM_SIZE_KWORDS => 1,      --Program size '1', '2' or '4'
                 C_JTAG_LOADER_ENABLE => 1)      --Include JTAG Loader when set to '1' 
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       rdl => kcpsm6_reset,
                       clk => clk);



	baud_signal: clk_to_baud 
	generic map ( N => 101)
	PORT MAP(
		clk => clk,
		reset => '0',
		baud_16x_en => en_16_x_baud
	);



  rx: uart_rx6 
  port map (            serial_in => uart_rx,
                     en_16_x_baud => en_16_x_baud,
                         data_out => uart_rx_data_out,
                      buffer_read => read_from_uart_rx,
              buffer_data_present => uart_rx_data_present,
                 buffer_half_full => uart_rx_half_full,
                      buffer_full => uart_rx_full,
                     buffer_reset => uart_rx_reset,              
                              clk => clk);

	
	
  tx: uart_tx6 
  port map (              data_in => uart_tx_data_in,
                     en_16_x_baud => en_16_x_baud,
                       serial_out => uart_tx,
                     buffer_write => write_to_uart_tx,
              buffer_data_present => uart_tx_data_present,
                 buffer_half_full => uart_tx_half_full,
                      buffer_full => uart_tx_full,
                     buffer_reset => uart_tx_reset,              
                              clk => clk);
	

	
	

  --
  -- In many designs (especially your first) interrupt and sleep are not used.
  -- Tie these inputs Low until you need them. Tying 'interrupt' to 'interrupt_ack' 
  -- preserves both signals for future use and avoids a warning message.
  -- 

  kcpsm6_sleep <= '0';
  interrupt <= interrupt_ack;


end Behavioral;

