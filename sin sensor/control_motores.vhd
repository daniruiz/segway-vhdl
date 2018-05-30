

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_motores is
    PORT ( reloj       : in STD_LOGIC;
           pos_x        : in STD_LOGIC_VECTOR (15 downto 0); -- Inclinación
           pos_y        : in STD_LOGIC_VECTOR (15 downto 0); -- Giro
          
           velocidad_A  : out STD_LOGIC_VECTOR (7 downto 0);
           L298N_IN1    : out STD_LOGIC; -- Sentido motor A _0
           L298N_IN2    : out STD_LOGIC; -- Sentido motor A _1
           L298N_IN3    : out STD_LOGIC; -- Sentido motor B _0
           L298N_IN4    : out STD_LOGIC; -- Sentido motor B _1
           velocidad_B  : out STD_LOGIC_VECTOR (7 downto 0) );

end control_motores;

architecture Comportamiento of control_motores is
    signal velocidad_A_absoluta : INTEGER := 0;
    signal velocidad_B_absoluta : INTEGER := 0;
    constant DEG_180            : STD_LOGIC_VECTOR (14 downto 0) := (others => '1');
    constant DEG_45             : INTEGER := to_integer(unsigned(DEG_180)) / 4;
begin
    process(reloj)
    begin
        if (reloj'event and reloj='1') then

            if abs(signed(pos_x)) > DEG_45 then
                velocidad_A <= (others => '1');
                velocidad_B <= (others => '1');
            else
                velocidad_A_absoluta <= to_integer(abs(signed(pos_x))) * 255 / DEG_45;
                velocidad_B_absoluta <= velocidad_A_absoluta;
            end if;
            
            L298N_IN1 <= pos_x(15);
            L298N_IN2 <= NOT pos_x(15);

            L298N_IN3 <= pos_x(15);
            L298N_IN4 <= NOT pos_x(15);
            
            velocidad_A <= STD_LOGIC_VECTOR(to_unsigned(velocidad_A_absoluta, velocidad_A'length));
            velocidad_B <= STD_LOGIC_VECTOR(to_unsigned(velocidad_B_absoluta, velocidad_B'length));

        end if;
    end process;

end Comportamiento;
