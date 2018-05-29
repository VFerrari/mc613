library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
use work.boliche_pack.all;
use work.boliche_tipos.all;

entity calcula_pontos is
port (clk    		: in std_logic;
		enable      : in std_logic;
		reset 		: in std_logic;
		botao       : in std_logic;
		pinos       : in std_logic_vector(9 downto 0);
		turno       : in std_logic_vector(3 downto 0);
		jog_atual	: in std_logic_vector(2 downto 0);
		pontos_jog	: out std_logic_vector(8 downto 0);
		jogada_at 	: out std_logic_vector(1 downto 0);
		acabou 		: out std_logic
	  );
end calcula_pontos;

architecture calc of calcula_pontos is

--Sinais

signal pontos_totais  : vetor_pontos := (others => (others => '0'));
signal strikes_norm	 : vetor_stsp := (others => (others => '0'));
signal spares_norm	 : vetor_stsp := (others => (others => '0'));
signal spare_spec     : vetor_spare_spec := (others => (others => '0'));
signal strikes_spec   : vetor_strike_spec := (others => (others => '0'));
signal pontos1_norm   : std_logic_vector(3 downto 0) := "0000";
signal pontos2_norm   : std_logic_vector(3 downto 0) := "0000";
signal pontos1_spec   : std_logic_vector(3 downto 0) := "0000";
signal pontos2_spec   : std_logic_vector(3 downto 0) := "0000";
signal pontos3_spec   : std_logic_vector(3 downto 0) := "0000";
signal jogada_at_norm : std_logic_vector(1 downto 0) := "00";
signal jogada_at_spec : std_logic_vector(1 downto 0) := "00";

signal ativar         : std_logic := '0';
signal ultima         : std_logic;
signal acabou_norm    : std_logic;
signal acabou_spec    : std_logic;


begin

	ultima <= '1' when turno = "1010" else '0';

	norm: rodada port map  (clk , 
									reset,
									enable, 
									botao , 
									pinos , 
									jogada_at_norm , 
									pontos1_norm , 
									pontos2_norm , 
									strikes_norm(to_integer(unsigned(jog_atual)))(to_integer(unsigned(turno))) , 
									spares_norm(to_integer(unsigned(jog_atual)))(to_integer(unsigned(turno))) , 
									acabou_norm);
								
	spec: rodada_spec port map	  (clk , 
											reset, 
											ultima,
											botao , 
											pinos ,
											jogada_at_spec,
											pontos1_spec , 
											pontos2_spec ,
											pontos3_spec , 
											strikes_spec(to_integer(unsigned(jog_atual))), 
											spare_spec(to_integer(unsigned(jog_atual))), 
											acabou_spec);

	process(clk)
	begin
		if(rising_edge(clk)) then
			if(turno = "1010") then
				ativar <= reset or acabou_spec;
			else
				ativar <= reset or acabou_norm;
			end if;
		end if;
	end process;
	
	process(ativar)
		variable ind_jog : integer;
		variable ind_tur: integer;
		variable pontos_rod: std_logic_vector(8 downto 0) := (others => '0');
		variable pontos1, pontos2, pontos3 : std_logic_vector(3 downto 0);
		
	begin
		if(rising_edge(ativar)) then
			if(reset = '1') then
				pontos_totais <= (others => (others => '0'));
				strikes_norm <= (others => (others => '0'));
				spares_norm <= (others => (others => '0'));
				strikes_spec <= (others => (others => '0'));
				spare_spec <= (others => (others => '0'));
				
			elsif(enable = '1') then
				ind_jog := to_integer(unsigned(jog_atual));
				
				--Caso especial : turno 1 (soma os pontos apenas)
				if (turno = "0001") then
					pontos1 := pontos1_norm;
					pontos2 := pontos2_norm;
					pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2));
				
				--Caso especial : turno 2 (soma os pontos e verifica turno 1)
				elsif (turno = "0010") then
					pontos1 := pontos1_norm;
					pontos2 := pontos2_norm;				
					pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2));
					
					-- Casos de strike e spare no turno 1
					if (strikes_norm(ind_jog)(1) = '1') then
						pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2));
					elsif (spares_norm(ind_jog)(1) = '1') then
						pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1));
					end if;
				
				-- Turnos de 3 a 9
				elsif (turno < "1010") then
					pontos1 := pontos1_norm;
					pontos2 := pontos2_norm;
					ind_tur := to_integer(unsigned(turno));
					
					-- Soma dos pontos
					pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2));
					
					-- Caso de spare no turno anterior
					if(spares_norm(ind_jog)(ind_tur-1) = '1') then
						pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1));						
					
					-- Caso de strike no turno anterior
					elsif(strikes_norm(ind_jog)(ind_tur-1) = '1') then
						pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2));
						
						-- Caso de duplo strike (woah)
						if (strikes_norm(ind_jog)(ind_tur-2) = '1') then
							pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1));
						end if;
					end if;
					
				-- Turno final - ate 3 jogadas
				else
					pontos1 := pontos1_spec;
					pontos2 := pontos2_spec;				
					pontos3 := pontos3_spec;
					
					-- Soma dos pontos
					pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2) + unsigned(pontos3));
					
					-- Caso strike no turno 9
					if (strikes_norm(ind_jog)(9) = '1') then
						pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1) + unsigned(pontos2));
					
						-- Caso de duplo strike (woah)
						if (strikes_norm(ind_jog)(8) = '1') then
							pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1));
						end if;
						
					-- Caso spare no turno 9
					elsif (spares_norm(ind_jog)(9) = '1') then
						pontos_rod := std_logic_vector(unsigned(pontos_rod) + unsigned(pontos1));
					end if;
				end if;
				
				pontos_totais(ind_jog) <= std_logic_vector(unsigned(pontos_totais(ind_jog)) + unsigned(pontos_rod));
				
			end if;
		end if;
	end process;
	
	pontos_jog <= pontos_totais(to_integer(unsigned(jog_atual)));
	jogada_at <= jogada_at_spec when turno = "1010" else jogada_at_norm;
	acabou <= acabou_spec when turno = "1010" else acabou_norm;
	
end calc;