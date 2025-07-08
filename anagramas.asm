; Programa que permita al usuario el ingreso de dos cadenas de caracteres, independientes entre si, 
; para luego determinar si las palabras o frases ingresadas son anagramas.      


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

inicio_programa:
    ; --- Entrada de la primera cadena ---
    lea dx, msg1
    call print_str
    lea di, cad1
    call leer_cadena

    ; --- Entrada de la segunda cadena ---
    lea dx, msg2
    call print_str
    lea di, cad2
    call leer_cadena

    ; Copiar cadenas para procesar
    lea si, cad1
    lea di, copia1
    call copiar_y_normalizar

    lea si, cad2
    lea di, copia2
    call copiar_y_normalizar

    ; Ordenar ambas cadenas
    lea si, copia1
    call ordenar

    lea si, copia2
    call ordenar

    ; Comparar ordenadas
    lea si, copia1
    lea di, copia2
    call comparar

    cmp al, 1
    je mostrar_si
    jne mostrar_no

mostrar_si:
    call color_verde
    lea dx, msgSI
    call print_str
    jmp repetir

mostrar_no:
    call color_rojo
    lea dx, msgNO
    call print_str

repetir:
    call color_blanco
    lea dx, msgRepetir
    call print_str
    mov ah, 1
    int 21h
    cmp al, 'S'
    je inicio_programa
    cmp al, 's'
    je inicio_programa
    mov ah, 4ch
    int 21h

; ----------------------------
; Subrutina: leer_cadena
; Entrada: DI apunta al destino
; Salida: Cadena en DI terminada con '$'
leer_cadena:
    mov cx, 0
.leer_loop:
    mov ah, 1
    int 21h
    cmp al, 13
    je fin_lectura
    mov [di], al
    inc di
    inc cx
    cmp cx, 45
    je fin_lectura
    jmp .leer_loop
fin_lectura:
    mov al, '$'
    mov [di], al
    ret

; ----------------------------
; Subrutina: print_str
; Muestra cadena terminada en '$'
print_str:
    mov ah, 09h
    int 21h
    ret

; ----------------------------
; Subrutina: copiar_y_normalizar
; Copia de SI a DI, eliminando espacios y pasando a min�scula
copiar_y_normalizar:
.siguiente:
    mov al, [si]
    cmp al, '$'
    je .fin
    cmp al, ' '
    je .ignorar
    call a_minuscula
    mov [di], al
    inc di
.ignorar:
    inc si
    jmp .siguiente
.fin:
    mov al, '$'
    mov [di], al
    ret

; ----------------------------
; Subrutina: a_minuscula
; Convierte AL a min�scula si es may�scula
a_minuscula:
    cmp al, 'A'
    jb .retornar
    cmp al, 'Z'
    ja .retornar
    add al, 32
.retornar:
    ret

; ----------------------------
; Subrutina: ordenar
; Ordena cadena en SI (bubble sort)
ordenar:
    push di
    push cx
    push dx
    lea di, si
    mov cx, 0
.contar:
    mov al, [di]
    cmp al, '$'
    je .inicio
    inc cx
    inc di
    jmp .contar
.inicio:
    dec cx
    mov dx, cx
.outer:
    mov di, si
    mov cx, dx
    jcxz .ordenado
.inner:
    mov al, [di]
    mov ah, [di+1]
    cmp al, ah
    jbe .nxt
    xchg al, ah
    mov [di], al
    mov [di+1], ah
.nxt:
    inc di
    loop .inner
    dec dx
    jnz .outer
.ordenado:
    pop dx
    pop cx
    pop di
    ret

; ----------------------------
; Subrutina: comparar
; Compara dos cadenas (SI y DI)
; Devuelve AL = 1 si iguales, 0 si no
comparar:
.loop:
    mov al, [si]
    mov ah, [di]
    cmp al, '$'
    jne .seguir
    cmp ah, '$'
    jne .no_iguales
    mov al, 1
    ret
.seguir:
    cmp al, ah
    jne .no_iguales
    inc si
    inc di
    jmp .loop
.no_iguales:
    mov al, 0
    ret

; ----------------------------
; Subrutinas para color en DOS (emu8086)

color_verde:
    mov ah, 09h
    mov dx, offset msgSI ; usar color verde: fondo negro, texto verde
    mov bh, 0
    mov bl, 2
    mov cx, 1
    ret

color_rojo:
    mov ah, 09h
    mov dx, offset msgNO
    mov bh, 0
    mov bl, 4
    mov cx, 1
    ret

color_blanco:
    mov ah, 09h
    mov dx, offset msgRepetir
    mov bh, 0
    mov bl, 7
    mov cx, 1
    ret

end main
