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
           ascii : in  STD_LOGIC_VECTOR (7 downto 0));
end nibble_to_ascii;

architecture Behavioral of nibble_to_ascii is

begin


end Behavioral;

