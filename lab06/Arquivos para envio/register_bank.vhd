library ieee;
use ieee.std_logic_1164.all;

entity register_bank is
  port (
    clk : in std_logic;
    data_in : in std_logic_vector(3 downto 0);
    data_out : out std_logic_vector(3 downto 0);
    reg_rd : in std_logic_vector(2 downto 0);
    reg_wr : in std_logic_vector(2 downto 0);
    we : in std_logic;
    clear : in std_logic
  );
end register_bank;

architecture structural of register_bank is
	
	-- Registrador padrao
	component reg is
	  generic (N : integer := 4);
		port (clk 	  : in std_logic;
				data_in : in std_logic_vector(N-1 downto 0);
				data_out: out std_logic_vector(N-1 downto 0);
				load 	  : in std_logic; 
				clear   : in std_logic);
	end component;
	
	-- Decoder
	component dec3_to_8 is
		port(en: in std_logic;
			  w : in std_logic_vector(2 downto 0);
			  y : out std_logic_vector(7 downto 0));
	end component;

	-- Buffer tri-state
	component zbuffer is
		port(x: in std_logic_vector (3 downto 0);
			  e: in std_logic;
			  f: out std_logic_vector(3 downto 0));
	end component;
	
	signal d2r		 : std_logic_vector(7 downto 0);
	signal r2d		 : std_logic_vector(7 downto 0);
	signal reg_exit : std_logic_vector(31 downto 0);
	
begin

	dec_in: dec3_to_8 port map (we, reg_wr, d2r);
	dec_out: dec3_to_8 port map ('1', reg_rd, r2d);
	
	G1: for i in 0 to 7 generate
		reg_i : reg 
						generic map (4)
						port map (clk, data_in, reg_exit(i*4+3 downto i*4), d2r(i), clear);
		
		tristate_i: zbuffer port map (reg_exit(i*4+3 downto i*4), r2d(i), data_out);
	end generate;

end structural;
