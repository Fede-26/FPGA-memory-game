library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Count_And_Toggle is
    generic (COUNT_LIMIT : natural);
    port (
        i_Clk : in std_logic;
        i_Enable : in std_logic;
        o_Toggle : out std_logic
    );
end entity Count_And_Toggle;

architecture rtl of Count_And_Toggle is
    signal r_Counter : natural range 0 to COUNT_LIMIT - 1;
begin
    process (i_Clk)
    begin
        if rising_edge(i_Clk) then
            if i_Enable = '1' then
                if r_Counter = COUNT_LIMIT - 1 then
                    r_Counter <= 0;
                    o_Toggle <= not o_Toggle;
                else
                    r_Counter <= r_Counter + 1;
                end if;
            else
                o_Toggle <= '0';
            end if;
        end if;
    end process;
end architecture rtl;