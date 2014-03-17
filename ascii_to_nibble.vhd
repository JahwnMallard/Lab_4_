----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:10:28 03/13/2014 
-- Design Name: 
-- Module Name:    ascii_to_nibble - Behavioral 
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

entity ascii_to_nibble is
    Port ( ascii : in  STD_LOGIC_VECTOR (7 downto 0);
           nibble : out  STD_LOGIC_VECTOR (3 downto 0));
end ascii_to_nibble;

architecture Behavioral of ascii_to_nibble is


begin

process(ascii)
begin	
	case ascii is
	
		when x"48" => nibble <= x"0" ;
		when x"49" => nibble <= x"1" ;
		when x"50" => nibble <= x"2" ; 
		when x"51" => nibble <= x"3" ;
		when x"52" => nibble <= x"4" ;
		when x"53" => nibble <= x"5" ;
		when x"54" => nibble <= x"6" ;
		when x"55" => nibble <= x"7" ;
		when x"56" => nibble <= x"8" ;
		when x"57" => nibble <= x"9" ;
		when x"65" => nibble <= x"A" ;
		when x"66" => nibble <= x"B" ;
		when x"67" => nibble <= x"C" ;
		when x"68" => nibble <= x"D" ;
		when x"69" => nibble <= x"E" ;
		when x"70" => nibble <= x"F" ;
		when others => nibble <= x"0" ;

	end case;

end process;

end Behavioral;

