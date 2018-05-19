library ieee;
use ieee.std_logic_1164.all;

entity ram is
  port (
    Clock : in std_logic;
    Address : in std_logic_vector(9 downto 0);
    DataIn : in std_logic_vector(31 downto 0);
    DataOut : out std_logic_vector(31 downto 0);
    WrEn : in std_logic
  );
end ram;

architecture rtl of ram is

component ram_block is
	port (Clock : in std_logic;
			Address : in std_logic_vector(6 downto 0);
			Data : in std_logic_vector(7 downto 0);
			Q : out std_logic_vector(7 downto 0);
			WrEn : in std_logic);
end component;

signal data1 : std_logic_vector (31 downto 0);
signal data2 : std_logic_vector (31 downto 0);
signal en1, en2: std_logic;

begin

	en1 <= WrEn when (Address(7) = '0' and Address(8) = '0' and Address(9) = '0') else '0';
	en2 <= WrEn when (Address(7) = '1' and Address(8) = '0' and Address(9) = '0') else '0';

	G1: for i in 4 downto 1 generate
		block_1_i: ram_block port map (Clock, Address(6 downto 0), DataIn((8*i)-1 downto 8*(i-1)), data1((8*i)-1 downto 8*(i-1)), en1);
	end generate;
	
	G2: for i in 4 downto 1 generate
		block_2_i: ram_block port map (Clock, Address(6 downto 0), DataIn((8*i)-1 downto 8*(i-1)), data2((8*i)-1 downto 8*(i-1)), en2);
	end generate;
	
	--Choosing which output is the correct one (Z if invalid)
	DataOut <= (others => 'Z') when (Address(9) = '1' or Address(8) = '1') 
										else data2 when Address(7) = '1'
										else data1;

end rtl;
