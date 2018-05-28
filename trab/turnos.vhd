library ieee ; 
use ieee.std_logic_1164.all;

entity turnos is
	port(clk 		 : in std_logic;
		  reset		 : in std_logic;
		  fim_turno  : in std_logic;
		  turno_atual: out std_logic_vector(3 downto 0);
		  fim_partida: out std_logic
		 );
end turnos;


architecture fsm of turnos is

type State_type is (t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, fim);
signal estado : State_type := t1;

signal troca : std_logic;

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			troca <= reset or fim_turno;
		end if;
	end process;
	
	process(troca)
	begin
		if (rising_edge(troca)) then
			if (reset = '1') then
				estado <= t1;
			else
				case estado is
				when t1 =>
					estado <= t2;
				
				when t2 =>
					estado <= t3;
				
				when t3 =>
					estado <= t4;
					
				when t4 =>
					estado <= t5;					
					
				when t5 =>
					estado <= t6;
					
				when t6 =>
					estado <= t7;
					
				when t7 =>
					estado <= t8;
					
				when t8 =>
					estado <= t9;
				
				when t9 =>
					estado <= t10;
				
				when t10 =>
					estado <= fim;
				
				when fim =>
					estado <= fim;
				end case;
			end if;
		end if;
	end process;

	fim_partida <= '1' when estado = fim else '0';
	
	with estado select
		turno_atual <= "0001" when t1,
							"0010" when t2,
							"0011" when t3,
							"0100" when t4,
							"0101" when t5,
							"0110" when t6,
							"0111" when t7,
							"1000" when t8,
							"1001" when t9,
							"1010" when others;
	

end fsm;