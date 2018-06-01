

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controlador is
    GENERIC  ( N_bits_datos : INTEGER := 16);
    PORT     ( reloj     : in  STD_LOGIC;
               pos_x     : in  STD_LOGIC_VECTOR(N_bits_datos-1 downto 0);
    
               L298N_ENA : out STD_LOGIC;
               L298N_IN1 : out STD_LOGIC;
               L298N_IN2 : out STD_LOGIC;
               L298N_IN3 : out STD_LOGIC;
               L298N_IN4 : out STD_LOGIC;
               L298N_ENB : out STD_LOGIC );
end controlador;

architecture Comportamiento of controlador is

    component control_motores is
        GENERIC  ( N_bits_datos   : INTEGER := 9);
        PORT     ( reloj          : in STD_LOGIC;
                   pos_x          : in STD_LOGIC_VECTOR (N_bits_datos-1 downto 0); -- Inclinación
                   pos_y          : in STD_LOGIC_VECTOR (N_bits_datos-1 downto 0); -- Giro
    
                   velocidad_A    : out STD_LOGIC_VECTOR (7 downto 0);
                   L298N_IN1      : out STD_LOGIC; -- Sentido motor A _0
                   L298N_IN2      : out STD_LOGIC; -- Sentido motor A _1
                   L298N_IN3      : out STD_LOGIC; -- Sentido motor B _0
                   L298N_IN4      : out STD_LOGIC; -- Sentido motor B _1
                   velocidad_B    : out STD_LOGIC_VECTOR (7 downto 0) );
    end component;

    component PWM is
        PORT    ( reloj           : in  STD_LOGIC;
                  valor           : in  STD_LOGIC_VECTOR(7 DOWNTO 0);

                  PWM             : out STD_LOGIC );
    end component;


    signal velocidad_A   : STD_LOGIC_VECTOR (7 downto 0);
    signal velocidad_B   : STD_LOGIC_VECTOR (7 downto 0);

begin

    i_control_motores: control_motores
        generic map ( N_bits_datos   => N_bits_datos )
        port map (
            reloj         => reloj,
            pos_x         => pos_x,
            pos_y         => (others => '0'),
          
            velocidad_A   => velocidad_A,
            L298N_IN1     => L298N_IN1,
            L298N_IN2     => L298N_IN2,
            L298N_IN3     => L298N_IN3,
            L298N_IN4     => L298N_IN4,
            velocidad_B   => velocidad_B );

    i_PWM_A: PWM port map (
            reloj         => reloj,
            valor         => velocidad_A,

            PWM           => L298N_ENA );

    i_PWM_B: PWM port map (
            reloj         => reloj,
            valor         => velocidad_B,

            PWM           => L298N_ENB );

end Comportamiento;
