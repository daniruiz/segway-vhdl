

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_motores is
    generic ( n_bits_datos : integer := 9 );
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

    signal velocidad_absoluta : integer;
    signal pos_x_absoluta     : integer;
    constant deg_180          : unsigned (n_bits_datos-2 downto 0) := (others => '1');
    constant deg              : integer := to_integer(deg_180) / 180;
    
    constant c1               : integer := (20*deg * 11 / (20*deg)) - (20*deg * 28 / (10*deg));
    constant c2               : integer := (30*deg * 28 / (10*deg) + c1) - (30*deg * 98 / (10*deg));
    constant c3               : integer := (40*deg * 98 / (10*deg) + c2) - (40*deg * 118 / (5*deg));
    signal contador           : integer := 0;
    signal lastError          : integer := 0;


    signal KpLastState        : std_logic := '0';
    signal KdLastState        : std_logic := '0';
    signal KiLastState        : std_logic := '0';
     
        
    function PID( angleFiltered, lastError, kp,kd,ki : integer) return integer is
    

        
        constant timeChange   : integer := 1;
        variable error        : integer := 0;
        variable errorSum     : integer := 0;
        variable dErr         : integer := 0;
        
    begin
        
        error := angleFiltered;
        errorSum := errorSum + error*timeChange;
        dErr := (error - lastError)/timeChange;
        
        return Kp * error + Ki * errorSum + Kd * dErr;
    
    end PID;

begin
    process(reloj)
    begin

        if (reloj'event and reloj='1') then
            contador <= contador + 1;
            
            -- ........................
            if(kpUp = '1' and KpLastState = '0') then
                KP <= KP + 10;
            end if;
            KpLastState <= kpUp;
            if(kdUp = '1' and KdLastState = '0') then
                Kd <= Kd + 1;
            end if;
            KdLastState <= kdUp;
            if(kiUp = '1' and KiLastState = '0') then
                Ki <= Ki + 1;
            end if;
            KiLastState <= kiUp;
            
            if (contador = 100000) then
                contador <= 0;
                pos_x_absoluta <= to_integer(abs(signed(x_gyro)));
                    
                    
                
                    l298n_in1 <= x_gyro(x_gyro'length - 1);
                    l298n_in2 <= not x_gyro(x_gyro'length - 1);
        
                    l298n_in3 <= x_gyro(x_gyro'length - 1);
                    l298n_in4 <= not x_gyro(x_gyro'length - 1);
                    
                    velocidad_absoluta <= PID(pos_x_absoluta, lastError,kp,kd,ki);
                    
                    velocidad_a <= std_logic_vector(to_unsigned(velocidad_absoluta, velocidad_a'length));
                    velocidad_b <= std_logic_vector(to_unsigned(velocidad_absoluta, velocidad_b'length));
                    
                    lastError <= pos_x_absoluta;
        
                end if;
            end if;
    end process;

end comportamiento;