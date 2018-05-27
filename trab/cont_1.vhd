library ieee ; 
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all;

entity cont_1 is
port (x : in std_logic_vector(1 to 10) ; 
		count : out std_logic_vector(3 downto 0)
		); 
end cont_1 ; 


architecture Behavior of cont_1 is
begin

process(x) 

-- conta nº de 1s em X 
variable tmp : integer;
begin 
	tmp := 0 ; 
	for i in 1 to 10 loop 
		if x(i) = '1' then 
			tmp := tmp + 1 ; 
		end if ; 
	end loop ; 

	count <= std_logic_vector(to_unsigned(tmp, 4));
end process ; 

end Behavior ;