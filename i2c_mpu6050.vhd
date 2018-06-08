


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c_mpu6050 is
    port( mclk        : in  std_logic;
          nrst        : in  std_logic;
          tic         : in  std_logic;
          srst        : out std_logic;
          dout        : out std_logic_vector(7 downto 0);
          rd          : out std_logic;
          we          : out std_logic;
          queued      : in  std_logic;
          nack        : in  std_logic;
          stop        : in  std_logic;
          data_valid  : in  std_logic;
          din         : in  std_logic_vector(7 downto 0);
          adr         : out std_logic_vector(3 downto 0);
          data        : out std_logic_vector(7 downto 0);
          load        : out std_logic;
          completed   : out std_logic;
          rescan      : in  std_logic );
end i2c_mpu6050;

architecture rtl of i2c_mpu6050 is

    type tstate is (s_idle, s_pwrmgt0, s_pwrmgt1, s_read0, s_read1, s_stable );
    signal state : tstate;
    signal adr_i : std_logic_vector(3 downto 0);

begin

    adr <= adr_i;

    oto: process(mclk, nrst)
    begin
        if (nrst = '0') then
            srst <='0';
            dout <= (others=>'0');
            rd <= '0';
            we <= '0';
            adr_i <= (others=>'0');
            load <= '0';
            data <= (others=>'1');
            completed <= '0';
            state <= s_idle;
        elsif (mclk'event and mclk = '1') then
            if (state = s_idle) then
                if (tic = '1') then
                    srst <='0';
                    dout <= (others=>'0');
                    rd <= '0';
                    we <= '0';
                    adr_i <= (others=>'0');
                    load <= '0';
                    data <= (others=>'1');
                    completed <= '0';
                    state <= s_pwrmgt0;
                end if;
            elsif (state = s_pwrmgt0) then -- init power management
                if (tic = '1') then
                    dout <= x"6b";
                    we <= '1';
                    rd <= '0';
                    if (queued = '1') then
                        dout <= x"00";
                        we <= '1';
                        rd <= '0';
                        state <= s_pwrmgt1;
                    elsif (nack = '1') then
                        state <= s_idle;
                    end if;
                end if;
            elsif (state = s_pwrmgt1) then
                if (tic = '1') then
                    if (queued = '1') then
                        dout <= x"00";
                        we <= '0';
                        rd <= '0';
                        state <= s_read0;
                    elsif (nack = '1') then
                        state <= s_idle;
                    end if;
                end if;
            elsif (state = s_read0) then    
                if (tic = '1') then
                    if (stop = '1') then
                        dout <= x"3b";    -- read 14 registers
                        we <= '1';
                        rd <= '0';
                    elsif (queued = '1') then
                        we <= '0';
                        rd <= '1';
                        adr_i <= (others=>'0');
                    elsif (data_valid = '1') then
                        load <= '1';
                        data <= din;
                        state <= s_read1;    
                    elsif (nack = '1') then
                        state <= s_idle;
                    end if;    
                end if;
            elsif (state = s_read1) then
                if (tic = '1') then
                    if (data_valid = '1') then
                        load <= '1';
                        data <= din;
                    elsif (queued = '1') then
                        adr_i <= std_logic_vector(to_unsigned( to_integer(unsigned( adr_i )) + 1, 4) );
                        if (adr_i = "1100") then  -- last one
                            we <= '0';
                            rd <= '0';
                        else
                            we <= '0';
                            rd <= '1';
                        end if;
                    elsif (stop = '1') then
                        state <= s_stable;
                    else
                        load <= '0';
                    end if;
                end if;
            elsif (state = s_stable) then
                completed <= '1';
                if (tic = '1') then
                    if (rescan = '1') then
                        state <= s_idle;
                    end if;
                end if;
            end if;
        end if;
    end process oto;

end rtl;

