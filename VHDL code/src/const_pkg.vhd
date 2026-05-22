-- Constants package (v1.0)
-- Written by P. Antonik, 2015
-- For Michiel's BPT project
-- Modified by E. Picco, 2023

library IEEE;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

package const_pkg is

    constant nNeurons   : integer := 50; --120; --600; --100; --50;
    constant nSamples   : integer := 32; --80; --16; --32;
    constant eAvg       : integer := 4; --4; --3;
    constant nLSkip     : integer := 8; --32; --4;
    constant nRSkip     : integer := 8; --32; --4;
    constant eAvgOfst   : integer := 8; --compute mean dc offset over 2^# samples

    constant nBRAMs     : integer := 8;
    constant lAddr      : integer := 13;

end const_pkg;
