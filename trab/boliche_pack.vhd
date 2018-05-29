library ieee; 
use ieee.std_logic_1164.all; 
use work.boliche_tipos.all;

package boliche_pack is
	component inicializador is
		port (CLOCK_50  :in std_logic;
				enable    :in std_logic;
				confirma  :in std_logic;
				quant     :in std_logic_vector(5 downto 0);
				fim 		 :out std_logic;
				n_jog		 :out std_logic_vector(2 downto 0);
				display   :out std_logic_vector(6 downto 0)
		     );
	end component;
	
	component andamento is
		port(clk    		: in std_logic;
			  enable 		: in std_logic;
			  reset  		: in std_logic;
			  botao  		: in std_logic;
			  n_jog  		: in std_logic_vector(2 downto 0);
			  pinos  		: in std_logic_vector(9 downto 0);
			  pontos_atuais: out vetor_disp;
			  jogador_atual: out std_logic_vector(6 downto 1);
			  turno_atual  : out std_logic_vector(6 downto 0);
			  jogada_atual : out std_logic_vector(6 downto 0);
			  pontos 		: out vetor_pontos;
			  fim_partida  : out std_logic
			 );
	end component;
	
	component final is
	port(clock       : in std_logic;
		  enable      : in std_logic;
		  reset       : in std_logic;
		  n_jog       : in std_logic_vector(2 downto 0);
		  jogs		  : in vetor_jogs;
		  pontos      : in vetor_pontos;
		  disp_pontos : out vetor_disp;
		  disp_jog    : out std_logic_vector(6 downto 0)
		 );
	end component;
	
	component ordena is
	port (clk 		   : in std_logic; 
			pontos_jogs : in vetor_pontos;
			pontos_pos  : out vetor_pontos;
			jogs_pos    : out vetor_jogs
			);
	end component; 
	
	component controle is
		port(clk  : in std_logic;
			  reset: in std_logic;
			  w    : in std_logic;
			  z    : out std_logic_vector(2 downto 0)
			 );
	end component;
	
	component jogadores is
		port(clk   : in std_logic;
			  reset : in std_logic;
			  troca : in std_logic;
			  n_jog : in std_logic_vector(2 downto 0);
			  fim_turno : out std_logic;
			  jog_at: out std_logic_vector(2 downto 0)
			 );
	end component;
	
	component turnos is
	port(clk 		 : in std_logic;
		  reset		 : in std_logic;
		  fim_turno  : in std_logic;
		  turno_atual: out std_logic_vector(3 downto 0);
		  fim_partida: out std_logic
		 );
	end component;
	
	component clk_div is
		generic(DIVISOR: natural  := 49999999
				  );
		port (clk 		 : in std_logic;
			   en  		 : in std_logic;
			   clk_lento : out std_logic
		     );
	end component;
	
	component gira_visor is
		port (clk		: in std_logic;
				strike	: in std_logic;
				spare		: in std_logic;
				gira_stop: out std_logic;
				seg_gira : out std_logic_vector(6 downto 0)
			  );
	end component;
	
	component bin2dec is
		port(bin: in std_logic_vector(3 downto 0);
			  dec: out std_logic_vector(6 downto 0)
			 );
	end component;

	component conversor_bcd is
    port(binario_in: in std_logic_vector(8 downto 0);
         bcd		 : out std_logic_vector(11 downto 0)
    );
	end component ;
	
	component cont_1 is
		port (X 		: in std_logic_vector(1 to 10) ; 
				Count : out std_logic_vector(3 downto 0)
		); 
	end component ;
	
	component calcula_pontos is
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
	end component;
	
	component rodada is
		port (clk    	 : in std_logic;
				enable    : in std_logic;
				reset 	 : in std_logic;
				arremesso : in std_logic;
				pinos  	 : in std_logic_vector(9 downto 0);
				jogada    : out std_logic_vector(1 downto 0);
				pontos1 	 : out std_logic_vector(3 downto 0);
				pontos2   : out std_logic_vector(3 downto 0);
				strike    : out std_logic;
				spare     : out std_logic;
				acabou 	 : out std_logic
			  );
	end component;
	
	component rodada_spec is
		port (clk    	 : in std_logic;
				reset  	 : in std_logic;
				enable 	 : in std_logic;
				arremesso : in std_logic;
				pinos  	 : in std_logic_vector(9 downto 0);
				jogada 	 : out std_logic_vector(1 downto 0);
				pontos1 	 : out std_logic_vector(3 downto 0);
				pontos2 	 : out std_logic_vector(3 downto 0);
				pontos3 	 : out std_logic_vector(3 downto 0);
				strikes 	 : out std_logic_vector(1 to 3);
				spares  	 : out std_logic_vector(2 to 3);
				acabou 	 : out std_logic
			  );
	end component;
	
end package;