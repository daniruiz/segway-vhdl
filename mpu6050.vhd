


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mpu6050 is
    port(
        reloj : in	  std_logic;
        SDA   : inout std_logic;
        SCL   : inout std_logic;

        XREG  : out   std_logic_vector(7 downto 0);
        YREG  : out   std_logic_vector(7 downto 0);
        ZREG  : out   std_logic_vector(7 downto 0)
    );
end mpu6050;

architecture Comportamiento of mpu6050 is

    component i2c_mpu6050
        port(
            MCLK       : in	 std_logic;
            nRST       : in	 std_logic;
            TIC        : in	 std_logic;
            SRST       : out std_logic;
            DOUT       : out std_logic_vector(7 downto 0);
            RD         : out std_logic;
            WE         : out std_logic;
            QUEUED     : in	 std_logic;
            NACK       : in	 std_logic;
            STOP       : in	 std_logic;
            DATA_VALID : in  std_logic;
            DIN        : in	 std_logic_vector(7 downto 0);
            ADR        : out std_logic_vector(3 downto 0);
            DATA       : out std_logic_vector(7 downto 0);
            LOAD       : out std_logic;
            COMPLETED  : out std_logic;
            RESCAN     : in  std_logic
        );
    end component;
    
    component I2CMASTER
        generic(
            DEVICE     : std_logic_vector(7 downto 0)
        );
        port(
            MCLK       : in  std_logic;
            nRST       : in  std_logic;
            SRST       : in  std_logic;
            TIC        : in  std_logic;
            DIN        : in  std_logic_vector(7 downto 0);
            DOUT       : out std_logic_vector(7 downto 0);
            RD         : in  std_logic;
            WE         : in  std_logic;
            NACK       : out std_logic;
            QUEUED     : out std_logic;
            DATA_VALID : out std_logic;
            STATUS     : out std_logic_vector(2 downto 0);
            STOP       : out std_logic;
            SCL_IN     : in  std_logic;
            SCL_OUT    : out std_logic;
            SDA_IN     : in  std_logic;
            SDA_OUT    : out std_logic
        );
    end component;


    signal TIC         : std_logic;
    signal SRST        : std_logic;
    signal DOUT        : std_logic_vector(7 downto 0);
    signal RD          : std_logic;
    signal WE          : std_logic;
    signal QUEUED      : std_logic;
    signal NACK        : std_logic;
    signal STOP        : std_logic;
    signal DATA_VALID  : std_logic;
    signal DIN         : std_logic_vector(7 downto 0);
    signal ADR         : std_logic_vector(3 downto 0);
    signal DATA        : std_logic_vector(7 downto 0);
    signal LOAD        : std_logic;
    signal COMPLETED   : std_logic;
    signal RESCAN      : std_logic;
    signal STATUS      : std_logic_vector(2 downto 0);
    signal SCL_IN      : std_logic;
    signal SCL_OUT     : std_logic;
    signal SDA_IN      : std_logic;
    signal SDA_OUT     : std_logic;

    signal counter     : std_logic_vector(7 downto 0);

begin

    I_i2c_mpu6050_0 : i2c_mpu6050
        port map (
            MCLK       => reloj,
            nRST       => '1',
            TIC        => TIC,
            SRST       => SRST,
            DOUT       => DIN,
            RD         => RD,
            WE         => WE,
            QUEUED     => QUEUED,
            NACK       => NACK,
            STOP       => STOP,
            DATA_VALID => DATA_VALID,
            DIN        => DOUT,
            ADR        => ADR,
            DATA       => DATA,
            LOAD       => LOAD,
            COMPLETED  => COMPLETED,
            RESCAN     => RESCAN
        );

    I_I2CMASTER_0 : I2CMASTER
        generic map (
            DEVICE     => x"68"
        )
        port map (
            MCLK       => reloj,
            nRST       => '1',
            SRST       => SRST,
            TIC        => TIC,
            DIN        => DIN,
            DOUT       => DOUT,
            RD         => RD,
            WE         => WE,
            NACK       => NACK,
            QUEUED     => QUEUED,
            DATA_VALID => DATA_VALID,
            STOP       => STOP,
            STATUS     => STATUS,
            SCL_IN     => SCL_IN,
            SCL_OUT    => SCL_OUT,
            SDA_IN     => SDA_IN,
            SDA_OUT    => SDA_OUT
        );

    TIC <= counter(7) and counter(5);

    process(reloj)
    begin
       if (reloj'event and reloj='1') then
            if (TIC = '1') then
                counter <= (others=>'0');
                
                if ( COMPLETED = '1' ) then
                    RESCAN <= '1';
                else
                    RESCAN <= '0';
                end if;
                
            if (LOAD = '1') then
                    if (ADR = x"0") then
                        XREG <= DATA;
                    elsif (ADR = x"2") then
                        YREG <= DATA;
                    elsif (ADR = x"4") then
                        ZREG <= DATA;
                    end if;
                end if;
            else
                counter <= std_logic_vector(to_unsigned(to_integer(unsigned( counter )) + 1, 8));
            end if;
        end if;
    end process;

    SCL <= 'Z' when SCL_OUT='1' else '0';
    SCL_IN <= to_UX01(SCL);
    SDA <= 'Z' when SDA_OUT='1' else '0';
    SDA_IN <= to_UX01(SDA);

end Comportamiento;

