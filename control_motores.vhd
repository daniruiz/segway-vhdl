

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_motores is
    PORT ( reloj        : in STD_LOGIC;
           pos_de       : in STD_LOGIC;
           pos_x        : in STD_LOGIC_VECTOR (15 downto 0); -- Inclinación
           pos_y        : in STD_LOGIC_VECTOR (15 downto 0); -- Giro
          
           velocidad_A  : out STD_LOGIC_VECTOR (7 downto 0);
           L298N_IN1    : out STD_LOGIC; -- Sentido motor A _0
           L298N_IN2    : out STD_LOGIC; -- Sentido motor A _1
           L298N_IN3    : out STD_LOGIC; -- Sentido motor B _0
           L298N_IN4    : out STD_LOGIC; -- Sentido motor B _1
           velocidad_B  : out STD_LOGIC_VECTOR (7 downto 0) );

end control_motores;

architecture Comportamiento of decodificador_mpu6050 is

begin

    process(reloj)
    begin
        if (reloj'event and reloj='1') then
            NULL;
        end if;
    end process;

end Comportamiento;
