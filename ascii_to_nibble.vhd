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
           nibble : in  STD_LOGIC_VECTOR (3 downto 0));
end ascii_to_nibble;

architecture Behavioral of ascii_to_nibble is

begin


end Behavioral;

