library ieee ; 
use ieee.std_logic_1164.all ; 

entity counter_1 is
port (X : in std_logic_vector(1 to 10) ; 
		Count : out integer range 0 to 10) ; 
end counter_1 ; 


architecture Behavior of counter_1 is
begin

process(X) 

-- conta nº de 1s em X 
variable tmp : integer;
begin 
	tmp := 0 ; 
	for i in 1 to 10 loop 
		if X(i) = '1' then 
			tmp := tmp + 1 ; 
		end if ; 
	end loop ; 

	Count <= tmp ; 
end process ; 

end Behavior ;