----------------------------------------------------------------
---- project name : i2c master
---- file         : i2cmaster.vhd
---- author       : philippe thirion
---- description  : i2c master finite state machine
---- modification history
---- 2016/06/04 
---- 2016/06/06 add stop
----------------------------------------------------------------

--    copyright philippe thirion
--    github.com/tirfil
--
--    copyright 2016 philippe thirion
--
--    this program is free software: you can redistribute it and/or modify
--    it under the terms of the gnu general public license as published by
--    the free software foundation, either version 3 of the license, or
--    (at your option) any later version.

--    this program is distributed in the hope that it will be useful,
--    but without any warranty; without even the implied warranty of
--    merchantability or fitness for a particular purpose.  see the
--    gnu general public license for more details.

--    you should have received a copy of the gnu general public license
--    along with this program.  if not, see <http://www.gnu.org/licenses/>.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- -- status -- --
-- idle      000
-- start     001
-- stop      111
-- sendbit   010
-- recvbit   101
-- checkack  011
-- sendack   110

entity i2cmaster is
    generic ( device      : std_logic_vector(7 downto 0) := x"38" );
    port    ( mclk        : in  std_logic;
              nrst        : in  std_logic;
              srst        : in  std_logic;                         -- synchronious reset
              tic         : in  std_logic;                         -- i2c rate (bit rate x3)
              din         : in  std_logic_vector(7 downto 0);      -- data to send
              dout        : out std_logic_vector(7 downto 0);      -- received data
              rd          : in  std_logic;                         -- read command
              we          : in  std_logic;                         -- write command
              nack        : out std_logic;                         -- nack from slave
              queued      : out std_logic;                         -- operation (write or read cycle) is queued
              data_valid  : out std_logic;                         -- new data available on dout
              stop        : out std_logic;
              status      : out std_logic_vector(2 downto 0);      -- state machine state
              scl_in      : in  std_logic;                         -- i2c signals
              scl_out     : out std_logic;
              sda_in      : in  std_logic;
              sda_out     : out std_logic );
end i2cmaster;

architecture rtl of i2cmaster is

    type tstate is (s_idle, s_start, s_sendbit, s_wesclup, s_wescldown, s_checkack, s_checkackup, s_checkackdown,
                    s_write, s_prestop, s_stop, s_read,s_recvbit, s_rdsclup, s_rdscldown, s_sendack, s_sendackup,
                    s_sendackdown, s_restart );
    signal state               : tstate;
    signal next_state          : tstate;
    signal counter             : std_logic_vector(3 downto 0);
    signal next_counter        : std_logic_vector(3 downto 0);
    signal shift               : std_logic_vector(7 downto 0);
    signal nackdet             : std_logic;

    signal sda_in_q, sda_in_qq : std_logic;

begin

    next_counter <= std_logic_vector(to_unsigned( to_integer(unsigned( counter )) + 1, 4) );

    resy: process(mclk, nrst)
    begin
        if (nrst = '0') then
            sda_in_q <= '1';
            sda_in_qq <= '1';
        elsif (mclk'event and mclk = '1') then
            sda_in_q <= sda_in;
            sda_in_qq <= sda_in_q;
        end if;
    end process resy;

    oto: process(mclk, nrst)
    begin
        if (nrst = '0') then
            status <= "000";
            state <= s_idle;
            scl_out <= '1';
            sda_out <= '1';
            nack <= '0';
            queued <= '0';
            data_valid <= '0';
            dout <= (others=>'0');
            counter <= (others=>'0');
            nackdet <= '0';
            shift <= (others=>'0');
            stop <= '0';
        elsif (mclk'event and mclk = '1') then
            if (srst = '1') then
                state <= s_idle;
            elsif (state = s_idle) then
                status <= "000";
                scl_out <= '1';
                sda_out <= '1';
                nack <= '0';
                queued <= '0';
                data_valid <= '0';
                dout <= (others=>'1');
                counter <= (others=>'0');
                stop <= '0';
                state <= s_idle;
                if (tic = '1') then
                    if (we = '1' or rd = '1') then
                        state <= s_start;
                    end if;
                end if;
            elsif (state = s_start) then
                status <= "001";
                scl_out <= '1';
                sda_out <= '0'; -- start bit
                nack <= '0';
                queued <= '0';
                stop <= '0';
                data_valid <= '0';
                if     (tic = '1') then
                    scl_out <= '0';
                    counter <= "0000";
                    shift(7 downto 1) <= device(6 downto 0);
                    if (we = '1') then 
                        shift(0) <= '0';
                        next_state <= s_write;
                    else
                        shift(0) <= '1'; -- rd='1'
                        next_state <= s_read;
                    end if;
                    state <= s_sendbit;
                end if;
            elsif (state =     s_sendbit) then
                if     (tic = '1') then
                    status <= "010";
                    scl_out <= '0';
                    sda_out <= shift(7);
                    shift(7 downto 1) <= shift(6 downto 0);
                    counter <= next_counter; 
                    nack <= '0';
                    queued <= '0';
                    stop <= '0';
                    data_valid <= '0';
                    state <= s_wesclup;
                end if;
            elsif (state = s_wesclup) then
                if     (tic = '1') then
                    nack <= '0';
                    queued <= '0';
                    data_valid <= '0';
                    scl_out <= '1';
                    state <= s_wescldown;
                end if;
            elsif (state = s_wescldown) then
                if     (tic = '1') then
                    nack <= '0';
                    queued <= '0';
                    stop <= '0';
                    data_valid <= '0';
                    scl_out <= '0';
                    if (counter(3) = '1') then
                        state <= s_checkack;
                    else
                        state <= s_sendbit;
                    end if;
                end if;
            elsif (state = s_checkack) then
                if     (tic = '1') then
                    status <= "011";
                    sda_out <= '1';
                    nack <= '0';
                    queued <= '0';
                    stop <= '0';
                    data_valid <= '0';
                    scl_out <= '0';
                    state <= s_checkackup;    
                end if;
            elsif (state = s_checkackup) then
                if     (tic = '1') then
                    nack <= '0';
                    queued <= '0';
                    stop <= '0';
                    scl_out <= '1';
                    if (sda_in_qq = '1') then
                        nackdet <= '1';
                    else
                        nackdet <= '0';
                    end if;
                    state <= s_checkackdown;    
                end if;
            elsif (state = s_checkackdown) then
                if     (tic = '1') then
                    nack <= '0';
                    queued <= '0';
                    stop <= '0';
                    data_valid <= '0';
                    scl_out <= '0';
                    state <= next_state;    -- s_write or s_read
                end if;
            elsif (state = s_write) then
                if (nackdet = '1') then
                    nack <= '1';
                    scl_out <= '0';
                    if     (tic = '1') then
                        nackdet <= '0';
                        sda_out <= '0';
                        state <= s_prestop;
                    end if;
                else
                    if (we = '1') then
                        shift <= din;
                        counter <= "0000";
                        queued <= '1';
                        data_valid <= '0';
                        state <= s_sendbit;
                    elsif (rd = '1') then    
                        scl_out <= '0';
                        sda_out <= '1';
                        if     (tic = '1') then
                            state <= s_restart; -- for restart
                        end if;
                    else
                        scl_out <= '0';
                        if     (tic = '1') then
                            sda_out <= '0';
                            state <= s_prestop;
                        end if;
                    end if;
                end if;
            elsif ( state = s_restart) then
                if     (tic = '1') then
                    state <= s_idle;
                end if;
            elsif (state = s_read) then
                if (nackdet = '1') then
                    nack <= '1';
                    scl_out <= '0';
                    if     (tic = '1') then
                        nackdet <= '0';
                        sda_out <= '0';
                        state <= s_prestop;
                    end if;
                else
                    if (rd = '1') then
                        shift <= (others=>'0');
                        counter <= "0000";
                        queued <= '1';
                        state <= s_recvbit;
                    elsif (we = '1') then    
                        scl_out <= '0';
                        sda_out <= '1';
                        if     (tic = '1') then
                            state <= s_idle; -- for restart
                        end if;
                    else
                        scl_out <= '0';
                        -- sda_out <= '0';
                        if     (tic = '1') then
                            sda_out <= '0';
                            state <= s_prestop;
                        end if;
                    end if;
                end if;
            elsif (state =     s_recvbit) then
                if     (tic = '1') then
                    status <= "101";
                    sda_out <= '1';
                    scl_out <= '0';
                    counter <= next_counter; 
                    nack <= '0';
                    queued <= '0';
                    stop <= '0';
                    data_valid <= '0';
                    state <= s_rdsclup;
                end if;
            elsif (state = s_rdsclup) then
                if     (tic = '1') then
                    nack <= '0';
                    queued <= '0';
                    stop <= '0';
                    data_valid <= '0';
                    scl_out <= '1';
                    shift(7 downto 1) <= shift(6 downto 0);
                    shift(0) <= sda_in_qq;
                    state <= s_rdscldown;
                end if;
            elsif (state = s_rdscldown) then
                if     (tic = '1') then
                    nack <= '0';
                    queued <= '0';
                    stop <= '0';
                    data_valid <= '0';
                    scl_out <= '0';
                    if (counter(3) = '1') then
                        state <= s_sendack;
                    else
                        state <= s_recvbit;
                    end if;
                end if;
            elsif (state = s_sendack) then
                if     (tic = '1') then
                    status <= "110";
                    if (rd = '1') then
                        sda_out <= '0';
                    else
                        sda_out <= '1';  -- last read 
                    end if;
                    dout <= shift;
                    nack <= '0';
                    queued <= '0';
                    stop <= '0';
                    data_valid <= '1';
                    scl_out <= '0';
                    state <= s_sendackup;
                end if;
            elsif (state = s_sendackup) then
                if     (tic = '1') then
                    -- sda_out <= '0';
                    nack <= '0';
                    queued <= '0';
                    stop <= '0';
                    data_valid <= '0';
                    scl_out <= '1';
                    state <= s_sendackdown;
                end if;
            elsif (state = s_sendackdown) then
                if     (tic = '1') then
                    -- sda_out <= '0';
                    nack <= '0';
                    queued <= '0';
                    stop <= '0';
                    data_valid <= '0';
                    scl_out <= '0';
                    state <= s_read;
                end if;            
            elsif (state = s_prestop) then
                if     (tic = '1') then
                    status <= "111";
                    stop <= '1';
                    scl_out <= '1';
                    sda_out <= '0';
                    nack <= '0';
                    state <= s_stop;
                end if;
            elsif (state = s_stop) then
                if     (tic = '1') then
                    scl_out <= '1';
                    sda_out <= '1';
                    state <= s_idle;
                end if;
            end if;
        end if;
    end process oto;

end rtl;

