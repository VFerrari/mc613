library ieee;
use ieee.std_logic_1164.all;
use work.boliche_pack.all;

entity gira_visor is
  port (
		clk		: in std_logic;
		strike	: in std_logic;
		spare		: in std_logic;
		gira_stop: out std_logic;
		seg_gira : out std_logic_vector(6 downto 0)
  );
end gira_visor;

architecture behavioral of gira_visor is

signal clk_2seg : std_logic;
signal clk_1dseg: std_logic;
signal sos      : std_logic;
type seg_atual_type is (A, B, C, D, E, F, G);
signal seg_atual : seg_atual_type := A;

begin

	sos <= strike or spare;
	
	DIV1: clk_div generic map (99999999) port map(clk , sos , clk_2seg);
	DIV2: clk_div generic map (4999999) port map(clk , '1', clk_1dseg);
	
	process(clk_2seg, clk)
	begin
		if (rising_edge(clk)) then
			if(clk_2seg = '1') then
				gira_stop <= '1';
			else
				gira_stop <= '0';
			end if;
		end if;
	end process;
	
	
	process(clk_1dseg, sos)
	begin
		if (rising_edge(clk_1dseg)) then
			if (sos = '0') then
				seg_atual <= A;
			else
				case seg_atual is
				when A =>
					seg_atual <= B;
				when B =>
					if (strike = '1') then
						seg_atual <= C;
					else 
						seg_atual <= G;
					end if;
				when C =>
					seg_atual <= D;
				when D =>
					seg_atual <= E;
				when E =>
					seg_atual <= F;
				when F =>
					seg_atual <= A;
				when G =>
					seg_atual <= F;
				end case;
			end if;
		end if;
	end process;
	
	with seg_atual select
		seg_gira <= "1111110" when A,
						"1111101" when B,
						"1111011" when C,
						"1110111" when D,
						"1101111" when E,
						"1011111" when F,
						"0111111" when G;			
	
end behavioral;