# GCD test program (subtraction method)
# Inputs:  inport0 (0xFFF8) = a, inport1 (0xFFFC) = b
# Output:  outport (0xFFFC) = gcd(a, b)
# Note: both inputs must be > 0, otherwise the loop never ends

        lw   $s0, 0xFFF8($zero)    # a = inport0
        lw   $s1, 0xFFFC($zero)    # b = inport1

loop:   beq  $s0, $s1, done        # if a == b, finished
        slt  $t0, $s0, $s1         # t0 = (a < b)
        bne  $t0, $zero, b_bigger  # if a < b, go subtract from b
        subu $s0, $s0, $s1         # a = a - b
        j    loop

b_bigger:
        subu $s1, $s1, $s0         # b = b - a
        j    loop

done:   sw   $s0, 0xFFFC($zero)    # outport = gcd
        halt
