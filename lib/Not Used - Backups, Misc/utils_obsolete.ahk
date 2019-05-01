;----------------------------------------------------
; hex2dec(p_hex_num)
;
; Converts hexadecimal number to a decimal number
; p_hex_num: is a hex number which can be either
;            the number itself or prefixed with 0x.
;            hex2dec("2F4E") is the same as hex2dec("0x2F4E")
;
; Returns a decimal number or 0 if p_hex_num is not a valid hex number.
;
;----------------------------------------------------
hex2dec(p_hex_num)
{
    if SubStr(p_hex_num, 1, 2) = "0x"
        p_hex_num := SubStr(p_hex_num, 3)
        
    Loop, Parse, p_hex_num
        reversed_hex_num := A_LoopField . reversed_hex_num

    hex_power_pos := StrSplit(reversed_hex_num)

    dec_num := 0
    for power_index, hex_digit in hex_power_pos
    {
        if (hex_digit = "A")
            dec_equivalent := 10
        else if (hex_digit = "B")
            dec_equivalent := 11
        else if (hex_digit = "C")
            dec_equivalent := 12
        else if (hex_digit = "D")
            dec_equivalent := 13
        else if (hex_digit = "E")
            dec_equivalent := 14
        else if (hex_digit = "F")
            dec_equivalent := 15
        else if (hex_digit >= "0") and (hex_digit <= "9")
            dec_equivalent := hex_digit 
        else
        {
            result := 0
            Goto HEX2DEC_EXIT
        }
        result += dec_equivalent * 16**(power_index - 1)
    }
HEX2DEC_EXIT:
    Return %result%
}
