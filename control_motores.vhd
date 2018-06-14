

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_motores is
    generic ( n_bits_datos : integer := 8 );
    port    ( reloj        : in std_logic;
              x_gyro       : in std_logic_vector (n_bits_datos-1 downto 0); -- inclinación
              y_gyro       : in std_logic_vector (n_bits_datos-1 downto 0); -- giro
              y_accel      : in std_logic_vector (n_bits_datos-1 downto 0);
              z_accel      : in std_logic_vector (n_bits_datos-1 downto 0);
              velocidad_a  : out std_logic_vector (7 downto 0);
              l298n_in1    : out std_logic; -- sentido motor a _0
              l298n_in2    : out std_logic; -- sentido motor a _1
              l298n_in3    : out std_logic; -- sentido motor b _0
              l298n_in4    : out std_logic; -- sentido motor b _1
              velocidad_b  : out std_logic_vector (7 downto 0);
              
              kpUp         : in std_logic;
              kdUP         : in std_logic;
              kiUP         : in std_logic;
              
              KP           : inout integer;
              KD           : inout integer;
              KI           : inout integer );
end control_motores;

architecture comportamiento of control_motores is

    constant timeChange        : integer := 1; -- 0.1 ns
    constant vel_offset        : integer := 70;

    signal velocidad           : integer;
    signal velocidad_a_integer : integer;
    signal velocidad_b_integer : integer;
    signal x_gyro_integer      : integer;
    signal y_gyro_integer      : integer;
   
    signal contador            : integer := 0;
    signal error               : integer := 0;
    signal dErr                : integer := 0;
    signal sum_error           : integer := 0;
    signal ultimo_error        : integer := 0;


    signal Kp_ultimo_estado    : std_logic := '0';
    signal Kd_ultimo_estado    : std_logic := '0';
    signal Ki_ultimo_estado    : std_logic := '0';
     
        
begin
    process(reloj)
    begin

        if (reloj'event and reloj='1') then
            contador <= contador + 1;
            
            -- ........................
            if(kpUp = '1' and Kp_ultimo_estado = '0') then
                KP <= KP + 10;
            end if;
            Kp_ultimo_estado <= kpUp;
            if(kdUp = '1' and Kd_ultimo_estado = '0') then
                Kd <= Kd + 10;
            end if;
            Kd_ultimo_estado <= kdUp;
            if(kiUp = '1' and Ki_ultimo_estado = '0') then
                Ki <= Ki + 1;
            end if;
            Ki_ultimo_estado <= kiUp;
            
            if (contador = 10000) then
                contador <= 0;
                
                x_gyro_integer <= to_integer(signed( x_gyro ));
                y_gyro_integer <= 0; -- <= to_integer(signed( y_gyro )) * 8;
                
                -- '''''''''''''''''''
                -- PID
                error <= x_gyro_integer;                      -- Proporción
                sum_error <= sum_error + error * timeChange;  -- Integración
                dErr <= (error - ultimo_error) / timeChange;  -- Derivación
                velocidad <= Kp * error + Ki * sum_error + Kd * dErr;
                ultimo_error <= error;
                

                velocidad_a_integer <= velocidad - y_gyro_integer;
                velocidad_b_integer <= velocidad + y_gyro_integer;
                
                if velocidad_a_integer > 255 then
                    velocidad_a_integer <= 255;
                end if;
                if velocidad_b_integer > 255 then
                    velocidad_b_integer <= 255;
                end if;
                if velocidad_a_integer < -255 then
                    velocidad_a_integer <= -255;
                end if;
                if velocidad_b_integer < -255 then
                    velocidad_b_integer <= -255;
                end if;
                
                velocidad_a <= std_logic_vector(to_unsigned(abs(velocidad_a_integer), velocidad_a'length));
                velocidad_b <= std_logic_vector(to_unsigned(abs(velocidad_b_integer), velocidad_b'length));
                
          
                l298n_in1 <= '0';
                l298n_in2 <= '1';
                l298n_in3 <= '0';
                l298n_in4 <= '1';
                                
                if velocidad_a_integer < 0 then
                    l298n_in1 <= '1';
                    l298n_in2 <= '0';
               end if;
               
               if velocidad_b_integer < 0 then
                   l298n_in3 <= '1';
                   l298n_in4 <= '0';
              end if;


            end if;
        end if;
    end process;
   

end comportamiento;