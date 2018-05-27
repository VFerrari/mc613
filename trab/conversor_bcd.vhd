library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity conversor_bcd is
    port(
        clk  : in std_logic;
		  reset: in std_logic;
        binario_in: in std_logic_vector(11 downto 0);
        bcd: out std_logic_vector(11 downto 0)
    );
end conversor_bcd ;
 
architecture conv of conversor_bcd is

	 -- Maquina de estados
    type estados is (inicia, shift, acaba);
    signal estado, estado_prox: estados;
 
    signal binario, binario_prox: std_logic_vector(11 downto 0);
    signal bcds, bcds_reg, bcds_prox: std_logic_vector(11 downto 0);
	 
    -- Registrador de saida
    signal bcds_out_reg, bcds_out_reg_prox: std_logic_vector(11 downto 0);
    
	 -- Precisa contar o numero de shifts
    signal shift_cont, shift_cont_prox: natural range 0 to 12;
begin
 
    process(clk, reset)
    begin
        if (reset = '1') then
            binario <= (others => '0');
            bcds <= (others => '0');
            estado <= inicia;
            bcds_out_reg <= (others => '0');
            shift_cont <= 0;
        elsif (falling_edge(clk)) then
            binario <= binario_prox;
            bcds <= bcds_prox;
            estado <= estado_prox;
            bcds_out_reg <= bcds_out_reg_prox;
            shift_cont <= shift_cont_prox;
        end if;
    end process;
 
    process(estado, binario, binario_in, bcds, bcds_reg, shift_cont)
    begin
        estado_prox <= estado;
        bcds_prox <= bcds;
        binario_prox <= binario;
        shift_cont_prox <= shift_cont;
 
        case estado is
            when inicia =>
                estado_prox <= shift;
                binario_prox <= binario_in;
                bcds_prox <= (others => '0');
                shift_cont_prox <= 0;
            when shift =>
                if shift_cont = 12 then
                    estado_prox <= acaba;
                else
                    binario_prox <= binario(10 downto 0) & 'L';
                    bcds_prox <= bcds_reg(10 downto 0) & binario(11);
                    shift_cont_prox <= shift_cont + 1;
                end if;
            when acaba =>
                estado_prox <= inicia;
        end case;
    end process;
 
    bcds_reg(11 downto 8)  <= bcds(11 downto 8)  + 3 when bcds(11 downto 8)  > 4 else bcds(11 downto 8);
    bcds_reg(7 downto 4)   <= bcds(7 downto 4) 	 + 3 when bcds(7 downto 4)   > 4 else bcds(7 downto 4);
    bcds_reg(3 downto 0)   <= bcds(3 downto 0) 	 + 3 when bcds(3 downto 0)   > 4 else bcds(3 downto 0);
 
    bcds_out_reg_prox <= bcds when estado = acaba else bcds_out_reg;
 
    bcd <= bcds_out_reg;
end conv;