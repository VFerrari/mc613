library ieee ; 
use ieee.std_logic_1164.all ; 

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
	
	component controle is
		port(clk  : in std_logic;
			  reset: in std_logic;
			  w    : in std_logic;
			  z    : out std_logic_vector(2 downto 0)
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
end package;