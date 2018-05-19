library ieee;
use ieee.std_logic_1164.all;

entity alu_board is
  port (
    SW : in std_logic_vector(9 downto 0);
    HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 : out std_logic_vector(6 downto 0);
    LEDR : out std_logic_vector(3 downto 0)
  );
end alu_board;

architecture behavioral of alu_board is

--ALU
component alu is
	port (a, b 		  : in std_logic_vector(3 downto 0);
			F 	  		  : out std_logic_vector(3 downto 0);
			s0, s1 	  : in std_logic;
			Z, C, V, N : out std_logic);
end component;

--Display logico
component bin2hex is
	port (SW  : in std_logic_vector(3 downto 0);
			HEX0: out std_logic_vector(6 downto 0));
end component;

--Display Matematico
component two_comp_to_7seg is
	port (bin : in std_logic_vector(3 downto 0);
			segs: out std_logic_vector(6 downto 0);
			neg : out std_logic);
end component;

--Argumentos
signal r: std_logic_vector(3 downto 0);
signal negs: std_logic_vector (2 downto 0);

--Saidas temporarias
signal Af1: std_logic_vector(6 downto 0);
signal Af2: std_logic_vector(6 downto 0);
signal Bf1: std_logic_vector(6 downto 0);
signal Bf2: std_logic_vector(6 downto 0);
signal Ff1: std_logic_vector(6 downto 0);
signal Ff2: std_logic_vector(6 downto 0);


begin
	ULA: alu port map (SW(7 downto 4), SW(3 downto 0), r, SW(9), 
							 SW(8), LEDR(3), LEDR(2), LEDR(1), LEDR(0));
	
	--Saidas logicas
	logicoA: bin2hex port map (SW(7 downto 4), Af1);
	logicoB: bin2hex port map (SW(3 downto 0), Bf1);
	logicoF: bin2hex port map (r, Ff1);
	
	--Saidas matematicas
	matA: two_comp_to_7seg port map (SW(7 downto 4), Af2, negs(0));
	matB: two_comp_to_7seg port map (SW(3 downto 0), Bf2, negs(1));
	matF: two_comp_to_7seg port map (r, Ff2, negs(2));
	
	--Negativos
	HEX5 <= "1111111" when SW(8)='1' else "0111111" when negs(0)='1' else "1111111";
	HEX3 <= "1111111" when SW(8)='1' else "0111111" when negs(1)='1' else "1111111";
	HEX1 <= "1111111" when SW(8)='1' else "0111111" when negs(2)='1' else "1111111";
	
	--Saidas
	HEX0 <= Ff1 when SW(8)='1' else Ff2;
	HEX2 <= Bf1 when SW(8)='1' else Bf2;
	HEX4 <= Af1 when SW(8)='1' else Af2;
	
end behavioral;
