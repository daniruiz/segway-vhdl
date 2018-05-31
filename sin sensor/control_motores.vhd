

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_motores is
    GENERIC ( N_bits_datos : INTEGER := 8 );
    PORT    ( reloj        : in STD_LOGIC;
              pos_x        : in STD_LOGIC_VECTOR (N_bits_datos-1 downto 0); -- Inclinación
              pos_y        : in STD_LOGIC_VECTOR (N_bits_datos-1 downto 0); -- Giro
              
              velocidad_A  : out STD_LOGIC_VECTOR (7 downto 0);
              L298N_IN1    : out STD_LOGIC; -- Sentido motor A _0
              L298N_IN2    : out STD_LOGIC; -- Sentido motor A _1
              L298N_IN3    : out STD_LOGIC; -- Sentido motor B _0
              L298N_IN4    : out STD_LOGIC; -- Sentido motor B _1
              velocidad_B  : out STD_LOGIC_VECTOR (7 downto 0) );

end control_motores;

architecture Comportamiento of control_motores is
    signal velocidad_absoluta  : INTEGER;
    signal pos_X_absoluta      : INTEGER;
    constant DEG_180           : UNSIGNED (N_bits_datos-2 downto 0) := (others => '1');
    constant DEG               : INTEGER := to_integer(DEG_180) / 180;
    
    constant C1                : INTEGER := (20*DEG * 11 / (20*DEG)) - (20*DEG * 28 / (10*DEG));
    constant C2                : INTEGER := (30*DEG * 28 / (10*DEG) + C1) - (30*DEG * 98 / (10*DEG));
    constant C3                : INTEGER := (40*DEG * 98 / (10*DEG) + C2) - (40*DEG * 118 / (5*DEG));
begin
    process(reloj)
    begin
        if (reloj'event and reloj='1') then
            pos_X_absoluta <= to_integer(abs(signed(pos_x)));
                
            -- Función exponencial ((255+1) ^ (1/DEG_45))^x - 1
            if    (pos_X_absoluta < (20*DEG)) then
                velocidad_absoluta <= pos_X_absoluta * 11 / (20*DEG);
            elsif (pos_X_absoluta = (20*DEG) or ((20*DEG) < pos_X_absoluta and pos_X_absoluta < (30*DEG))) then
                velocidad_absoluta <= pos_X_absoluta * 28 / (10*DEG) + C1;
            elsif (pos_X_absoluta = (30*DEG) or ((30*DEG) < pos_X_absoluta and pos_X_absoluta < (40*DEG))) then
                velocidad_absoluta <= pos_X_absoluta * 98 / (10*DEG) + C2;
            elsif (pos_X_absoluta = (40*DEG) or ((40*DEG) < pos_X_absoluta and pos_X_absoluta < (45*DEG))) then
                velocidad_absoluta <= pos_X_absoluta * 118 / (5*DEG) + C3;
            elsif (pos_X_absoluta = 45*DEG or 45*DEG < pos_X_absoluta) then
                velocidad_absoluta <= 255;
            end if;
            
            L298N_IN1 <= pos_x(15);
            L298N_IN2 <= NOT pos_x(15);

            L298N_IN3 <= pos_x(15);
            L298N_IN4 <= NOT pos_x(15);
            
            velocidad_A <= STD_LOGIC_VECTOR(to_unsigned(velocidad_absoluta, velocidad_A'length));
            velocidad_B <= STD_LOGIC_VECTOR(to_unsigned(velocidad_absoluta, velocidad_B'length));

        end if;
    end process;

end Comportamiento;
