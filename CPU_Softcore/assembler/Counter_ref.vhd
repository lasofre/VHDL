ARCHITECTURE mapped OF programRom IS

  subtype opCodeType is std_ulogic_vector(5 downto 0);
  constant opLoadC   : opCodeType := "000000";
  constant opLoadR   : opCodeType := "000001";
  constant opInputC  : opCodeType := "000100";
  constant opInputR  : opCodeType := "000101";
  constant opFetchC  : opCodeType := "000110";
  constant opFetchR  : opCodeType := "000111";
  constant opAndC    : opCodeType := "001010";
  constant opAndR    : opCodeType := "001011";
  constant opOrC     : opCodeType := "001100";
  constant opOrR     : opCodeType := "001101";
  constant opXorC    : opCodeType := "001110";
  constant opXorR    : opCodeType := "001111";
  constant opTestC   : opCodeType := "010010";
  constant opTestR   : opCodeType := "010011";
  constant opCompC   : opCodeType := "010100";
  constant opCompR   : opCodeType := "010101";
  constant opAddC    : opCodeType := "011000";
  constant opAddR    : opCodeType := "011001";
  constant opAddCyC  : opCodeType := "011010";
  constant opAddCyR  : opCodeType := "011011";
  constant opSubC    : opCodeType := "011100";
  constant opSubR    : opCodeType := "011101";
  constant opSubCyC  : opCodeType := "011110";
  constant opSubCyR  : opCodeType := "011111";
  constant opShRot   : opCodeType := "100000";
  constant opOutputC : opCodeType := "101100";
  constant opOutputR : opCodeType := "101101";
  constant opStoreC  : opCodeType := "101110";
  constant opStoreR  : opCodeType := "101111";

  subtype shRotCinType is std_ulogic_vector(2 downto 0);
  constant shRotLdC : shRotCinType := "00-";
  constant shRotLdM : shRotCinType := "01-";
  constant shRotLdL : shRotCinType := "10-";
  constant shRotLd0 : shRotCinType := "110";
  constant shRotLd1 : shRotCinType := "111";

  constant registerAddressBitNb : positive := 4;
  constant shRotPadLength : positive
    := dataOut'length - opCodeType'length - registerAddressBitNb
     - 1 - shRotCinType'length;
  subtype shRotDirType is std_ulogic_vector(1+shRotPadLength-1 downto 0);
  constant shRotL : shRotDirType := (0 => '0', others => '-');
  constant shRotR : shRotDirType := (0 => '1', others => '-');

  subtype branchCodeType is std_ulogic_vector(4 downto 0);
  constant brRet  : branchCodeType := "10101";
  constant brCall : branchCodeType := "11000";
  constant brJump : branchCodeType := "11010";
  constant brReti : branchCodeType := "11100";
  constant brEni  : branchCodeType := "11110";

  subtype branchConditionType is std_ulogic_vector(2 downto 0);
  constant brDo : branchConditionType := "000";
  constant brZ  : branchConditionType := "100";
  constant brNZ : branchConditionType := "101";
  constant brC  : branchConditionType := "110";
  constant brNC : branchConditionType := "111";

  subtype memoryWordType is std_ulogic_vector(dataOut'range);
  type memoryArrayType is array (0 to 2**address'length-1) of memoryWordType;

  signal memoryArray : memoryArrayType := (
    16#000# => opLoadC   & "0010" & "00000001",
    16#001# => opInputC  & "0101" & "00000001",
    16#002# => opLoadC   & "0000" & "00000000",
    16#003# => opOutputR & "0000" & "0010----",
    16#004# => brCall    & brDo   & "0000001001",
    16#005# => opCompR   & "0000" & "0101----",
    16#006# => brJump    & brZ    & "0000000001",
    16#007# => opAddR    & "0000" & "0010----",
    16#008# => brJump    & brDo   & "0000000011",
    16#009# => opLoadC   & "0001" & "00000000",
    16#00A# => opAddR    & "0001" & "0010----",
    16#00B# => opLoadC   & "0011" & "00000000",
    16#00C# => opAddR    & "0011" & "0010----",
    16#00D# => opLoadC   & "0100" & "00000000",
    16#00E# => opAddR    & "0100" & "0010----",
    16#00F# => opCompC   & "0100" & "11111111",
    16#010# => brJump    & brNZ   & "0000001110",
    16#011# => opCompC   & "0011" & "11111111",
    16#012# => brJump    & brNZ   & "0000001100",
    16#013# => opCompC   & "0001" & "11111111",
    16#014# => brJump    & brNZ   & "0000001010",
    16#015# => brRet     & brDo   & "----------",
    others => (others => '0')
  );

BEGIN

  process (clock)
  begin
    if rising_edge(clock) then
      if en = '1' then
        dataOut <= memoryArray(to_integer(address));
      end if;
    end if;
  end process;

END ARCHITECTURE mapped;
