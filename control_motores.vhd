

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_motores is
    generic ( n_bits_datos : integer := 9 );
    port    ( reloj        : in std_logic;
              pos_x        : in std_logic_vector (n_bits_datos-1 downto 0); -- inclinación
              pos_y        : in std_logic_vector (n_bits_datos-1 downto 0); -- giro
              velocidad_a  : out std_logic_vector (7 downto 0);
              l298n_in1    : out std_logic; -- sentido motor a _0
              l298n_in2    : out std_logic; -- sentido motor a _1
              l298n_in3    : out std_logic; -- sentido motor b _0
              l298n_in4    : out std_logic; -- sentido motor b _1
              velocidad_b  : out std_logic_vector (7 downto 0) );
end control_motores;

architecture comportamiento of control_motores is

    signal velocidad_absoluta : integer;
    signal pos_x_absoluta     : integer;
    constant deg_180          : unsigned (n_bits_datos-2 downto 0) := (others => '1');
    constant deg              : integer := to_integer(deg_180) / 180;
    
    constant c1               : integer := (20*deg * 11 / (20*deg)) - (20*deg * 28 / (10*deg));
    constant c2               : integer := (30*deg * 28 / (10*deg) + c1) - (30*deg * 98 / (10*deg));
    constant c3               : integer := (40*deg * 98 / (10*deg) + c2) - (40*deg * 118 / (5*deg));

begin
    process(reloj)
    begin

        if (reloj'event and reloj='1') then
            pos_x_absoluta <= to_integer(abs(signed(pos_x)));
                
            -- función exponencial ((255+1) ^ (1/deg_45))^x - 1
            if    (pos_x_absoluta < (20*deg)) then
                velocidad_absoluta <= pos_x_absoluta * 11 / (20*deg);
            elsif (pos_x_absoluta = (20*deg) or ((20*deg) < pos_x_absoluta and pos_x_absoluta < (30*deg))) then
                velocidad_absoluta <= pos_x_absoluta * 28 / (10*deg) + c1;
            elsif (pos_x_absoluta = (30*deg) or ((30*deg) < pos_x_absoluta and pos_x_absoluta < (40*deg))) then
                velocidad_absoluta <= pos_x_absoluta * 98 / (10*deg) + c2;
            elsif (pos_x_absoluta = (40*deg) or ((40*deg) < pos_x_absoluta and pos_x_absoluta < (45*deg))) then
                velocidad_absoluta <= pos_x_absoluta * 118 / (5*deg) + c3;
            elsif (pos_x_absoluta = 45*deg or 45*deg < pos_x_absoluta) then
                velocidad_absoluta <= 255;
            end if;
            
            l298n_in1 <= pos_x(pos_x'length - 1);
            l298n_in2 <= not pos_x(pos_x'length - 1);

            l298n_in3 <= pos_x(pos_x'length - 1);
            l298n_in4 <= not pos_x(pos_x'length - 1);
            
            velocidad_a <= std_logic_vector(to_unsigned(velocidad_absoluta, velocidad_a'length));
            velocidad_b <= std_logic_vector(to_unsigned(velocidad_absoluta, velocidad_b'length));

        end if;
    end process;

end comportamiento;
