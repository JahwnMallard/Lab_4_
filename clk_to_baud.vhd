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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_to_baud is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           baud_16x_en : out  STD_LOGIC);
end clk_to_baud;

architecture Behavioral of clk_to_baud is

begin


end Behavioral;

