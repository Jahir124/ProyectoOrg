; Programa que permita al usuario el ingreso de dos cadenas de caracteres, independientes entre si, 
; para luego determinar si las palabras o frases ingresadas son anagramas.      


.model small
.stack 100h
.data
    msg1 db 13,10, 'Ingrese la primera cadena: $'
    msg2 db 13,10, 'Ingrese la segunda cadena: $'
    msgSI db 13,10, 'Son anagramas', 13,10, '$'
    msgNO db 13,10, 'No son anagramas', 13,10, '$'
    msgRepetir db 13,10, 'Quiere probar con otras cadenas? (S/N): $'

    cad1 db 46 dup('$')     ; Hasta 45 caracteres + '$'
    cad2 db 46 dup('$')
    copia1 db 46 dup('$')
    copia2 db 46 dup('$')

.code
main:
    mov ax, @data
    mov ds, ax


end main
