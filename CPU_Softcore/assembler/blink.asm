        ;---------------------------------------------------------------
        ; Test "INPUT" and "OUTPUT" direct
        ;
        ; The testbench should invert the word written at address FC.
        ;---------------------------------------------------------------
        LOAD      s2, 01
loop:   LOAD      s0, F0
        OUTPUT    s0, (s2)
        CALL      delay
        LOAD      s0, 0F
        OUTPUT    s0, (s2)
        CALL      delay
        JUMP      loop
delay:  LOAD      s1, 00
for:    ADD       s1, s2
        LOAD      s3, 00
for2:   ADD       s3, s2
        LOAD      s4, 00
for3:   ADD       s4, s2
        COMPARE   s4, FF
        JUMP      NZ, for3
        COMPARE   s3, FF
        JUMP      NZ, for2
        COMPARE   s1, FF
        JUMP      NZ, for
        RETURN
        