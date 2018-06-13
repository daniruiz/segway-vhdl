


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mpu6050 is
    port ( reloj   : in    std_logic;
           sda     : inout std_logic;
           scl     : inout std_logic;
           y_gyro  : out   std_logic_vector(7 downto 0);
           x_gyro  : out   std_logic_vector(7 downto 0);
           z_gyro  : out   std_logic_vector(7 downto 0);
           y_accel : out   std_logic_vector(7 downto 0);
           x_accel : out   std_logic_vector(7 downto 0);
           z_accel : out   std_logic_vector(7 downto 0) );
end mpu6050;

architecture comportamiento of mpu6050 is

    component i2c_mpu6050
        port(
            mclk       : in  std_logic;
            nrst       : in  std_logic;
            tic        : in  std_logic;
            srst       : out std_logic;
            dout       : out std_logic_vector(7 downto 0);
            rd         : out std_logic;
            we         : out std_logic;
            queued     : in  std_logic;
            nack       : in  std_logic;
            stop       : in  std_logic;
            data_valid : in  std_logic;
            din        : in  std_logic_vector(7 downto 0);
            adr        : out std_logic_vector(3 downto 0);
            data       : out std_logic_vector(7 downto 0);
            load       : out std_logic;
            completed  : out std_logic;
            rescan     : in  std_logic
        );
    end component;
    
    component i2cmaster
        generic(
            device     : std_logic_vector(7 downto 0)
        );
        port(
            mclk       : in  std_logic;
            nrst       : in  std_logic;
            srst       : in  std_logic;
            tic        : in  std_logic;
            din        : in  std_logic_vector(7 downto 0);
            dout       : out std_logic_vector(7 downto 0);
            rd         : in  std_logic;
            we         : in  std_logic;
            nack       : out std_logic;
            queued     : out std_logic;
            data_valid : out std_logic;
            status     : out std_logic_vector(2 downto 0);
            stop       : out std_logic;
            scl_in     : in  std_logic;
            scl_out    : out std_logic;
            sda_in     : in  std_logic;
            sda_out    : out std_logic
        );
    end component;


    signal tic         : std_logic;
    signal srst        : std_logic;
    signal dout        : std_logic_vector(7 downto 0);
    signal rd          : std_logic;
    signal we          : std_logic;
    signal queued      : std_logic;
    signal nack        : std_logic;
    signal stop        : std_logic;
    signal data_valid  : std_logic;
    signal din         : std_logic_vector(7 downto 0);
    signal adr         : std_logic_vector(3 downto 0);
    signal data        : std_logic_vector(7 downto 0);
    signal load        : std_logic;
    signal completed   : std_logic;
    signal rescan      : std_logic;
    signal status      : std_logic_vector(2 downto 0);
    signal scl_in      : std_logic;
    signal scl_out     : std_logic;
    signal sda_in      : std_logic;
    signal sda_out     : std_logic;

    signal counter     : std_logic_vector(7 downto 0);
    
    signal temp_data   : std_logic_vector(7 downto 0);

begin

    i_i2c_mpu6050_0 : i2c_mpu6050
        port map (
            mclk       => reloj,
            nrst       => '1',
            tic        => tic,
            srst       => srst,
            dout       => din,
            rd         => rd,
            we         => we,
            queued     => queued,
            nack       => nack,
            stop       => stop,
            data_valid => data_valid,
            din        => dout,
            adr        => adr,
            data       => data,
            load       => load,
            completed  => completed,
            rescan     => rescan );

    i_i2cmaster_0 : i2cmaster
        generic map ( device     => x"68" )
        port map (
            mclk       => reloj,
            nrst       => '1',
            srst       => srst,
            tic        => tic,
            din        => din,
            dout       => dout,
            rd         => rd,
            we         => we,
            nack       => nack,
            queued     => queued,
            data_valid => data_valid,
            stop       => stop,
            status     => status,
            scl_in     => scl_in,
            scl_out    => scl_out,
            sda_in     => sda_in,
            sda_out    => sda_out );

    tic <= counter(7) and counter(5);

    process(reloj)
    begin
       if (reloj'event and reloj='1') then
            if (tic = '1') then
                counter <= (others=>'0');
                
                if ( completed = '1' ) then
                    rescan <= '1';
                else
                    rescan <= '0';
                end if;
                
                if (load = '1') then
                    case adr is
                        when x"0" => y_gyro <= data;
                        when x"2" => x_gyro <= data;
                        when x"4" => z_gyro <= data;

                        when x"8" => y_accel <= data;
                        when x"a" => x_accel <= data;
                        when x"c" => z_accel <= data;
                        when others => null;
                    end case;
                end if;
            else
                counter <= std_logic_vector(to_unsigned(to_integer(unsigned( counter )) + 1, 8));
            end if;
        end if;
    end process;


    scl <= 'Z' when scl_out='1' else '0';
    scl_in <= to_ux01(scl);
    sda <= 'Z' when sda_out='1' else '0';
    sda_in <= to_ux01(sda);

end comportamiento;

