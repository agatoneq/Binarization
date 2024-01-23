.data
    wektor_3 dd 3, 3, 3, 3

.code
    binarization PROC
    ; RCX - wynikowa bitmapa
    ; RDX - tablica R
    ; R8 - tablica G
    ; R9 - tablica B
    
    mov r11, [rsp+40]   ; rozmiar
    mov r10, [rsp+48]   ; pr�g binaryzacji   
    mov rsi, [rsp+56]   ; licznik
    mov r12, [rsp+64]
    
    ; wczytywanie wektora 4-el z tr�jkami do xmm3
    movups xmm3, xmmword ptr [wektor_3]
    cvtdq2ps xmm3, xmm3
    
    ;rozpakowanie progu binaryzacji do xmm5 i zrobienie 8-el wektora
    movd xmm5, r10
    punpckldq  xmm5, xmm5
    punpckldq  xmm5, xmm5
        
    main_loop:
        ; wczytywanie tablic 128 bit�w
        movdqu xmm0, [rdx+rsi]
        movdqu xmm1, [r8+rsi]
        movdqu xmm2, [r9+rsi]

        ; dodawanie 128b rejestrow (s��w 16bitowych)
        paddw xmm0, xmm1
        paddw xmm0, xmm2
        
        ; Konwertuj do float (dzi�ki temu divps b�dzie dzia�a� na 32-bitowych s�owach)
        cvtdq2ps xmm0, xmm0
        
        ; Wykonaj dzielenie
        divps xmm0, xmm3
        
        ; Skonwertuj z powrotem do 32-bitowych s��w
        cvtps2dq xmm0, xmm0

        ; por�wanie warto�ci xmm0 z xmm5 (progiem binaryzacji)
        cmpltps xmm5, xmm0

        ; zapisanie wyniku binaryzacji do wynikowej bitmapy
        vmovdqu8 [rcx + r12], xmm5
        add r12, 1
        vmovdqu8 [rcx + r12], xmm5
        add r12, 1
        vmovdqu8 [rcx + r12], xmm5
        add r12, 1
        
        ;ponowne rozpakowanie progu binaryzacji do xmm5 i zrobienie 8-el wektora
        movd xmm5, r10
        punpckldq  xmm5, xmm5
        punpckldq  xmm5, xmm5

        ; zwi�kszenie indeksu o 8 bajt�w
        add rsi, 4

        ; sprawdzanie warunku zako�czenia p�tli
        cmp rsi, r11
        jl main_loop

        ; zako�czenie procedury
        ret

   binarization endp
end