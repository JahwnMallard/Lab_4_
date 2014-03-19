----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:11:01 03/13/2014 
-- Design Name: 
-- Module Name:    nibble_to_ascii - Behavioral 
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

entity nibble_to_ascii is
    Port ( nibble : in  STD_LOGIC_VECTOR (3 downto 0);
           ascii : out  STD_LOGIC_VECTOR (7 downto 0));
end nibble_to_ascii;

architecture Behavioral of nibble_to_ascii is

begin

process(Nibble)
begin	
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

end process;

end Behavioral;

