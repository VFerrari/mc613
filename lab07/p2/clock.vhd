library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clock is
  port (
    clk : in std_logic;
    decimal : in std_logic_vector(3 downto 0);
    unity : in std_logic_vector(3 downto 0);
    set_hour : in std_logic;
    set_minute : in std_logic;
    set_second : in std_logic;
    hour_dec, hour_un : out std_logic_vector(6 downto 0);
    min_dec, min_un : out std_logic_vector(6 downto 0);
    sec_dec, sec_un : out std_logic_vector(6 downto 0)
  );
end clock;

architecture rtl of clock is

  -- Clock divider
  component clk_div is
    port (
      clk : in std_logic;
      clk_hz : out std_logic
    );
  end component;
  
  --Display
  component bin2dec is
  	port (bin: in std_logic_vector(3 downto 0);
			dec: out std_logic_vector(6 downto 0));
  end component;
  
  signal clk_hz : std_logic;
  
  signal hour_dec_buf, hour_un_buf : std_logic_vector(3 downto 0);
  signal min_dec_buf, min_un_buf : std_logic_vector(3 downto 0);
  signal sec_dec_buf, sec_un_buf : std_logic_vector(3 downto 0);
  
  signal start: std_logic := '1';

begin
	clock_divider : clk_div port map (clk, clk_hz);
	
	process(clk_hz, set_hour, set_minute, set_second)
	begin
	
	-- Set manually - Asynchronous
	-- Stopping malicious users from setting inexistent times.
	if (set_hour = '1' and ((decimal < "0011" and unity < "0100") or (decimal < "0010" and unity <= "1001"))) then
		hour_dec_buf <= decimal;
		hour_un_buf  <= unity;
		
	elsif (set_minute = '1' and decimal < "0111" and unity <= "1001") then
		min_dec_buf <= decimal;
		min_un_buf  <= unity;
	elsif (set_second = '1' and decimal < "0111" and unity <= "1001") then
		sec_dec_buf <= decimal;
		sec_un_buf  <= unity;
	elsif (start = '1') then
		start <= '0';
		hour_dec_buf <= "0000";
		hour_un_buf <= "0000";
		min_dec_buf <= "0000";
		min_un_buf <= "0000";
		sec_dec_buf <= "0000";
		sec_un_buf <= "0000";
		
	-- Counter: clock
	elsif (clk_hz'event and clk_hz = '1') then
		sec_un_buf <= sec_un_buf + 1;
		
		if (sec_un_buf >= "1001") then
			sec_un_buf <= "0000";
			sec_dec_buf <= sec_dec_buf + 1;
				
			if (sec_dec_buf >= "0101") then
				sec_dec_buf <= "0000";
				min_un_buf <= min_un_buf + 1;
					
				if (min_un_buf >= "1001") then
					min_un_buf <= "0000";
					min_dec_buf <= min_dec_buf + 1;
					
					if (min_dec_buf >= "0101") then
						min_dec_buf <= "0000";
						hour_un_buf <= hour_un_buf + 1;
						
						-- Special case
						if (hour_un_buf >= "0011" and hour_dec_buf >= "0010") then
							hour_un_buf <= "0000";
							hour_dec_buf <= "0000";
						
						-- Regular case
						elsif (hour_un_buf >= "1001") then
							hour_un_buf <= "0000";
							hour_dec_buf <= hour_dec_buf + 1;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
		
	end process;
	
	--Seconds
	display_un_sec: bin2dec port map(sec_un_buf, sec_un);
	display_dec_sec: bin2dec port map(sec_dec_buf, sec_dec);
	
	--Minutes
	display_un_min: bin2dec port map(min_un_buf, min_un);
	display_dec_min: bin2dec port map(min_dec_buf, min_dec);

	--Hours
	display_un_hour: bin2dec port map(hour_un_buf, hour_un);
	display_dec_hour: bin2dec port map(hour_dec_buf, hour_dec);

end rtl;