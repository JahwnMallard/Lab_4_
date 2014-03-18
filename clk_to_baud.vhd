----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:12:14 03/13/2014 
-- Design Name: 
-- Module Name:    clk_to_baud - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_to_baud is
	 generic (N : integer);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           baud_16x_en : out  STD_LOGIC);
end clk_to_baud;

architecture Behavioral of clk_to_baud is

signal baud_count : integer range 0 to N ;
signal en_16_x_baud : std_logic ;

begin


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

baud_16x_en <= en_16_x_baud;
end Behavioral;