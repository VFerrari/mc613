library ieee;
use ieee.std_logic_1164.all;

entity extra_logic is
  port(w3, w2, w1, w0 : in std_logic;
       y3, y2, y1, y0 : in std_logic;
       f : out std_logic);
end extra_logic;

architecture rtl of extra_logic is

signal d0, d1, d2, d3 :std_logic;
begin
  f <= d0 or d1 or d2 or d3;
  d0 <= w0 and y0;
  d1 <= w1 and y1;
  d2 <= w2 and y2;
  d3 <= w3 and y3;
end rtl;

