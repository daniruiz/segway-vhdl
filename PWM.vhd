

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
    port ( reloj : in  std_logic;
           valor : in  std_logic_vector(7 downto 0);
           pwm   : out std_logic );
end pwm;

architecture comportamiento of pwm is

    signal contador : unsigned(7 downto 0) := (others => '0');

begin

    process(reloj)
    begin
        if (reloj'event and reloj='1') then
            -- salida a 1 durante `valor` ciclos
            if unsigned(contador) < unsigned(valor) or unsigned(contador) = unsigned(valor)  then
                pwm <= '1';
            else
                pwm <= '0';
            end if;

            -- reiniciar/incrementar contador cada 255 ciclos
            if contador = to_unsigned(255, contador'length) then
                contador <= (others => '0');
            else
                contador <= contador + 1;
            end if;
        end if;
    end process;

end comportamiento;
