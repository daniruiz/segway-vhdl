

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlador is
    port ( reloj     : in    std_logic;
           sda       : inout std_logic;
           scl       : inout std_logic;
           l298n_ena : out   std_logic;
           l298n_in1 : out   std_logic;
           l298n_in2 : out   std_logic;
           l298n_in3 : out   std_logic;
           l298n_in4 : out   std_logic;
           l298n_enb : out   std_logic );
end controlador;

architecture comportamiento of controlador is

    component control_motores is
        generic  ( n_bits_datos : integer := 9);
        port     ( reloj        : in std_logic;
                   pos_x        : in std_logic_vector (n_bits_datos-1 downto 0); -- inclinación
                   pos_y        : in std_logic_vector (n_bits_datos-1 downto 0); -- giro
                   velocidad_a  : out std_logic_vector (7 downto 0);
                   l298n_in1    : out std_logic; -- sentido motor a _0
                   l298n_in2    : out std_logic; -- sentido motor a _1
                   l298n_in3    : out std_logic; -- sentido motor b _0
                   l298n_in4    : out std_logic; -- sentido motor b _1
                   velocidad_b  : out std_logic_vector (7 downto 0) );
    end component;
    
    component mpu6050 is
        port     ( reloj        : in    std_logic;
                   sda          : inout std_logic;
                   scl          : inout std_logic;
                   y_gyro       : out   std_logic_vector(15 downto 0);
                   x_gyro       : out   std_logic_vector(15 downto 0);
                   z_gyro       : out   std_logic_vector(15 downto 0);
                   y_accel      : out   std_logic_vector(15 downto 0);
                   x_accel      : out   std_logic_vector(15 downto 0);
                   z_accel      : out   std_logic_vector(15 downto 0) );
    end component;

    component pwm is
        port     ( reloj        : in  std_logic;
                   valor        : in  std_logic_vector(7 downto 0);
                   pwm          : out std_logic );
    end component;


    constant n_bits_datos : integer := 16;

    signal velocidad_a    : std_logic_vector (7 downto 0);
    signal velocidad_b    : std_logic_vector (7 downto 0);
    signal y_gyro         : std_logic_vector (n_bits_datos - 1 downto 0);
    signal x_gyro         : std_logic_vector (n_bits_datos - 1 downto 0);
    signal z_gyro         : std_logic_vector (n_bits_datos - 1 downto 0);
    signal y_accel        : std_logic_vector (n_bits_datos - 1 downto 0);
    signal x_accel        : std_logic_vector (n_bits_datos - 1 downto 0);
    signal z_accel        : std_logic_vector (n_bits_datos - 1 downto 0);
    
begin

    i_mpu6050: mpu6050
        port map (
            reloj         => reloj,
            sda           => sda,
            scl           => scl,
            y_gyro        => y_gyro,
            x_gyro        => x_gyro,
            z_gyro        => z_gyro,
            y_accel       => y_accel,
            x_accel       => x_accel,
            z_accel       => z_accel );

    i_control_motores: control_motores
        generic map ( n_bits_datos => n_bits_datos )
        port map (
            reloj       => reloj,
            pos_x       => x_gyro,
            pos_y       => (others => '0'),
            velocidad_a => velocidad_a,
            l298n_in1   => l298n_in1,
            l298n_in2   => l298n_in2,
            l298n_in3   => l298n_in3,
            l298n_in4   => l298n_in4,
            velocidad_b => velocidad_b );

    i_pwm_a: pwm
        port map (
            reloj       => reloj,
            valor       => velocidad_a,
            pwm         => l298n_ena );

    i_pwm_b: pwm
        port map (
            reloj       => reloj,
            valor       => velocidad_b,
            pwm         => l298n_enb );

end comportamiento;
