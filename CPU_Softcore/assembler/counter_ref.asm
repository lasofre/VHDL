        ;---------------------------------------------------------------
        ; Test "INPUT" and "OUTPUT" direct
        ;
        ; The testbench should invert the word written at address FC.
        ;---------------------------------------------------------------
        LOAD      s2, 01
sta:    INPUT     s5, 01
        LOAD      s0, 00
loop:   OUTPUT    s0, (s2)
        CALL      delay
        COMPARE   s0, s5
        JUMP      Z , sta
        ADD       s0, s2
        JUMP      loop
delay:  LOAD      s1, 00
for:    ADD       s1, s2
        LOAD      s3, 00
ford:   ADD       s3, s2
        LOAD      s4, 00
fort:   ADD       s4, s2
        COMPARE   s4, FF
        JUMP      NZ , fort
        COMPARE   s3, FF
        JUMP      NZ , ford
        COMPARE   s1, FF
        JUMP      NZ , for
        RETURN