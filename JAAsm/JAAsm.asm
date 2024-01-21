.data
    wektor_3 dd 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0

.code
    binarization PROC
    ; RCX - wynikowa bitmapa
    ; RDX - tablica R
    ; R8 - tablica G
    ; R9 - tablica B
    
    mov r11, [rsp+40]   ; rozmiar/3
    mov r10, [rsp+48]   ; pr�g binaryzacji   
    mov rsi, 0          ; licznik

    main_loop:
        ; wczytywanie tablic 128 bit�w
        movdqu xmm0, [rdx+rsi]
        movdqu xmm1, [r8+rsi]
        movdqu xmm2, [r9+rsi]

        ; dodawanie 128b rejestrow
        paddusb xmm0, xmm1
        paddusb xmm0, xmm2

        ; wczytywanie wektora 16-el z tr�jkami do xmm3
        movups xmm3, xmmword ptr [wektor_3]

        ; Podzielenie xmm0 przez xmm3
        divps xmm0, xmm3

        ;rozpakowanie progu binaryzacji do xmm4 i zrobienie 16-el wektora
        movd xmm4, r10
        punpckldq xmm4, xmm4
        punpckldq xmm4, xmm4

        ; por�wanie warto�ci xmm0 z xmm4 (progiem binaryzacji)
        cmpltss xmm0, xmm4

        ; zapisanie wyniku binaryzacji do wynikowej bitmapy
        movaps [rcx + rsi], xmm0

        ; zwi�kszenie indeksu o 16 bajt�w
        add rsi, 16 

        ; sprawdzanie warunku zako�czenia p�tli
        cmp rsi, r11
        jl main_loop

        ; zako�czenie procedury
        ret

   binarization endp
end