

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rs232_115200_rx is
    PORT ( reloj          : in  STD_LOGIC;
           entrada_serie  : in  STD_LOGIC;

           byte_datos     : out STD_LOGIC_VECTOR (7 downto 0);
           byte_datos_de  : out STD_LOGIC );
end rs232_115200_rx;

architecture Comportamiento of rs232_115200_rx is
    signal entrada_serie_temp   : STD_LOGIC := '0';
    signal entrada_serie_seguro : STD_LOGIC := '0';

    signal contador             : UNSIGNED(13 downto 0)        := (others => '0');
    
    -- Buffer de bits entrantes
    signal byte_datos_sr        : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    
    -- Constantes para tiempos de bits cada 10 ns
    constant medio_bit          : INTEGER := 100000000/115200/2;
    constant bit_completo       : INTEGER := 100000000/115200;
begin
    byte_datos <= byte_datos_sr;
    process(reloj)
    begin
        if (reloj'event and reloj='1') then
            byte_datos_de <= '0';
            if contador = 0 then
                -- Este es el flanco de bajada del bit de inicio
                if entrada_serie_seguro = '0' then
                    contador <= contador + 1;
                end if;
            else
                -- Recoge los bits a 115200bps (espera inicial de 1.5bit veces para el bit de inicio)
                if      contador = to_unsigned(medio_bit + 1 * bit_completo, contador'length) or
                        contador = to_unsigned(medio_bit + 2 * bit_completo, contador'length) or
                        contador = to_unsigned(medio_bit + 3 * bit_completo, contador'length) or
                        contador = to_unsigned(medio_bit + 4 * bit_completo, contador'length) or
                        contador = to_unsigned(medio_bit + 5 * bit_completo, contador'length) or
                        contador = to_unsigned(medio_bit + 6 * bit_completo, contador'length) or
                        contador = to_unsigned(medio_bit + 7 * bit_completo, contador'length) or
                        contador = to_unsigned(medio_bit + 8 * bit_completo, contador'length) then
                    byte_datos_sr <= entrada_serie_seguro & byte_datos_sr(7 downto 1);
                    
                elsif   contador = to_unsigned(medio_bit + 9 * bit_completo, contador'length) then
                    byte_datos_de <= entrada_serie_seguro;
                end if;
                
                if contador = to_unsigned(medio_bit + 9 * bit_completo + 1, contador'length) then
                    if entrada_serie_seguro = '0' then
                        contador <= (others => '0');
                    end if;
                else
                    contador <= contador + 1;
                end if;
            end if;
            
            -- Sincronizar la entrada en serie
            entrada_serie_seguro <= entrada_serie_temp;
            entrada_serie_temp <= entrada_serie;
        end if;
    end process;

end Comportamiento;
