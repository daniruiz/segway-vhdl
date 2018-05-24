

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decodificador_mpu6050 is
    PORT ( reloj         : in  STD_LOGIC;
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

end decodificador_mpu6050;

architecture Comportamiento of decodificador_mpu6050 is

    -- Constantes para el protocolo del sensor
    constant BYTE_CABECERA : STD_LOGIC_VECTOR(7 downto 0) := x"55";
    constant CABECERA_AC   : STD_LOGIC_VECTOR(7 downto 0) := x"51";
    constant CABECERA_ROT  : STD_LOGIC_VECTOR(7 downto 0) := x"52";
    constant CABECERA_POS  : STD_LOGIC_VECTOR(7 downto 0) := x"53";
    
    -- Array de caracteres;
    type c_array is array(0 to 9) of STD_LOGIC_VECTOR (7 downto 0);
    signal c      : c_array := (others => (others => '0'));

    signal chksum : UNSIGNED(7 downto 0) := (others => '0');
    
begin
    process(reloj)
    begin
        if (reloj'event and reloj='1') then
            ac_de <= '0';
            rot_de <= '0';
            pos_de <= '0';
            if byte_datos_de = '1' then
                -- Actualización del checksum
                chksum <= chksum + unsigned(byte_datos) - unsigned(c(0));
                
                -- Desplazamiento de los caracteres
                c(0 to 8) <= c(1 to 9);
                c(9)      <= byte_datos;
                if c(0) = CABECERA_AC then
                    -- Verificación errores
                    if chksum = unsigned(byte_datos) then
                        case c(1) is
                            when CABECERA_AC => -- Aceleración
                                ac_x     <= c(3) & c(2);
                                ac_y     <= c(5) & c(4);
                                ac_z     <= c(7) & c(6);
                                ac_de    <= '1';
                            when CABECERA_ROT => -- Rotación
                                rot_x     <= c(3) & c(2);
                                rot_y     <= c(5) & c(4);
                                rot_z     <= c(7) & c(6);
                                rot_de    <= '1';
                            when CABECERA_POS => -- Posición
                                pos_x     <= c(3) & c(2);
                                pos_y     <= c(5) & c(4);
                                pos_z     <= c(7) & c(6);
                                pos_de    <= '1';
                            when others => NULL;
                        end case;
                    end if;
                end if;
            end if;
        end if;
    end process;
end Comportamiento;
