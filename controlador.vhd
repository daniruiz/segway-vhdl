

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controlador is
    PORT ( mpu6050   : in   STD_LOGIC;

           L298N_ENA : out  STD_LOGIC;
           L298N_IN1 : out  STD_LOGIC;
           L298N_IN2 : out  STD_LOGIC;
           L298N_IN3 : out  STD_LOGIC;
           L298N_IN4 : out  STD_LOGIC;
           L298N_ENB : out  STD_LOGIC );
end controlador;

architecture Comportamiento of controlador is
    
    component rs232_115200_rx is
        Port ( reloj         : in  STD_LOGIC;
               entrada_serie : in  STD_LOGIC;

               byte_datos    : out STD_LOGIC_VECTOR (7 downto 0);
               byte_datos_de : out STD_LOGIC );
    end component;

    component decodificador_mpu6050 is
        Port ( reloj         : in  STD_LOGIC;
               byte_datos    : in  STD_LOGIC_VECTOR (7 downto 0);
               byte_datos_de : in  STD_LOGIC;

               ac_x          : out STD_LOGIC_VECTOR (15 downto 0);
               ac_y          : out STD_LOGIC_VECTOR (15 downto 0);
               ac_z          : out STD_LOGIC_VECTOR (15 downto 0);
               ac_de         : out STD_LOGIC;

               rot_x         : out STD_LOGIC_VECTOR (15 downto 0);
               rot_y         : out STD_LOGIC_VECTOR (15 downto 0);
               rot_z         : out STD_LOGIC_VECTOR (15 downto 0);
               rot_de        : out STD_LOGIC;

               pos_x         : out STD_LOGIC_VECTOR (15 downto 0);
               pos_y         : out STD_LOGIC_VECTOR (15 downto 0);
               pos_z         : out STD_LOGIC_VECTOR (15 downto 0);
               pos_de        : out STD_LOGIC );
    end component;

    component control_motores is
        Port ( reloj          : in STD_LOGIC;
               pos_x          : in STD_LOGIC_VECTOR (15 downto 0); -- Inclinación
               pos_y          : in STD_LOGIC_VECTOR (15 downto 0); -- Giro
          
               velocidad_A    : out STD_LOGIC_VECTOR (7 downto 0);
               L298N_IN1      : out STD_LOGIC; -- Sentido motor A _0
               L298N_IN2      : out STD_LOGIC; -- Sentido motor A _1
               L298N_IN3      : out STD_LOGIC; -- Sentido motor B _0
               L298N_IN4      : out STD_LOGIC; -- Sentido motor B _1
               velocidad_B    : out STD_LOGIC_VECTOR (7 downto 0) );
    end component;

    component PWM is
        Port ( reloj         : in  STD_LOGIC;
               valor         : in  STD_LOGIC_VECTOR(7 DOWNTO 0);

               PWM           : out STD_LOGIC );
    end component;


    signal reloj         : STD_LOGIC;

    signal byte_datos    : STD_LOGIC_VECTOR (7 downto 0);
    signal byte_datos_de : STD_LOGIC;

    signal ac_x          : STD_LOGIC_VECTOR (15 downto 0);
    signal ac_y          : STD_LOGIC_VECTOR (15 downto 0);
    signal ac_z          : STD_LOGIC_VECTOR (15 downto 0);
    signal ac_de         : STD_LOGIC;

    signal rot_x         : STD_LOGIC_VECTOR (15 downto 0);
    signal rot_y         : STD_LOGIC_VECTOR (15 downto 0);
    signal rot_z         : STD_LOGIC_VECTOR (15 downto 0);
    signal rot_de        : STD_LOGIC;

    signal pos_x         : STD_LOGIC_VECTOR (15 downto 0);
    signal pos_y         : STD_LOGIC_VECTOR (15 downto 0);
    signal pos_z         : STD_LOGIC_VECTOR (15 downto 0);
    signal pos_de        : STD_LOGIC;


    signal velocidad_A   : STD_LOGIC_VECTOR (7 downto 0);
    signal velocidad_B   : STD_LOGIC_VECTOR (7 downto 0);

begin
    i_rs232_115200_rx: rs232_115200_rx port map (
            reloj         => reloj,
            entrada_serie => mpu6050,

            byte_datos    => byte_datos,
            byte_datos_de => byte_datos_de );

    i_mpu6050_decode: decodificador_mpu6050 port map (
            reloj         => reloj,
            byte_datos    => byte_datos,
            byte_datos_de => byte_datos_de,

            ac_x          => ac_x,
            ac_y          => ac_y,
            ac_z          => ac_z,
            ac_de         => ac_de,
            rot_x         => rot_x,
            rot_y         => rot_y,
            rot_z         => rot_z,
            rot_de        => rot_de,
            pos_x         => pos_x,
            pos_y         => pos_y,
            pos_z         => pos_z,
            pos_de        => pos_de );

    i_control_motores: control_motores port map (
            reloj         => pos_de,
            pos_x         => pos_x,
            pos_y         => pos_y,
          
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

    process
    begin
        reloj <= '0';
        wait for 10 ns;
        reloj <= '1';
        wait for 10 ns;
    end process;

end Comportamiento;
