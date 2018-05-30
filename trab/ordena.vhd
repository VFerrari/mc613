library ieee ; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.boliche_tipos.all;

entity ordena is
port (clk  : in std_logic; 
		pontos_jogs : in vetor_pontos;
		pontos_pos  : out vetor_pontos;
		jogs_pos    : out vetor_jogs
		);
end ordena; 

architecture sort of ordena is

	
begin

    process (clk, pontos_jogs)
        variable temp:      std_logic_vector (8 downto 0);
		  variable temp2:      std_logic_vector (2 downto 0);
        variable pontos_jogs_aux:     vetor_pontos; 
		  variable jogs_pos_aux   :     vetor_jogs;
    begin
        pontos_jogs_aux := pontos_jogs;
		  jogs_pos_aux := ("001", "010", "011" , "100" , "101", "110");
		  
        if rising_edge(clk) then
            for j in 1 to 5 loop 
                for i in 1 to 6 - j loop 
					 
                    if (unsigned(pontos_jogs_aux(i)) < unsigned(pontos_jogs_aux(i + 1))) then
						
							   --Pontos
                        temp := pontos_jogs_aux(i);
                        pontos_jogs_aux(i) := pontos_jogs_aux(i + 1);
                        pontos_jogs_aux(i + 1) := temp;
								
								--Jogadores
								temp2 := jogs_pos_aux(i);
								jogs_pos_aux(i) := jogs_pos_aux(i + 1);
                        jogs_pos_aux(i + 1) := temp2;
                    end if;
                end loop;
            end loop;
				
          pontos_pos <= pontos_jogs_aux;
			 jogs_pos <= jogs_pos_aux;
        end if;
    end process;


end sort;
