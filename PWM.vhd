

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM is
    PORT ( reloj : in  STD_LOGIC;
           valor : in  STD_LOGIC_VECTOR(7 DOWNTO 0);

           PWM   : out STD_LOGIC );
end PWM;

architecture Comportamiento of PWM is

    signal contador : unsigned(7 downto 0) := (others => '0');

begin

    process(reloj)
    begin
        if (reloj'event and reloj='1') then
            -- Salida a 1 durante `valor` ciclos
            if unsigned(contador) < unsigned(valor) or unsigned(contador) = unsigned(valor)  then
                PWM <= '1';
            else
                PWM <= '0';
            end if;

            -- Reiniciar/incrementar contador cada ciclo
            if contador = to_unsigned(255, contador'length) then
                contador <= (others => '0');
            else
                contador <= contador + 1;
            end if;
        end if;
    end process;

end Comportamiento;
