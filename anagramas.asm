; Programa que permita al usuario el ingreso de dos cadenas de caracteres, independientes entre si, 
; para luego determinar si las palabras o frases ingresadas son anagramas.      


; Programa que permita al usuario el ingreso de dos cadenas de caracteres, independientes entre si, 
; para luego determinar si las palabras o frases ingresadas son anagramas.      


.model small
.stack 100h


.data
    msg1 db 13,10, 'Ingrese la primera cadena: $'
    msg2 db 13,10, 'Ingrese la segunda cadena: $'
    msgSI db 13,10, 'Son anagramas$'
    msgNO db 13,10, 'No son anagramas$'
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
call limpiar_pantalla
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
     lea si, msgSI
    mov bl, 0x0A      ; Verde claro
    call imprimir_bios_color
    jmp repetir

mostrar_no:
    lea si, msgNO
    mov bl, 0x0C      ; Rojo claro
    call imprimir_bios_color

repetir:
    lea si, msgRepetir
    mov bl, 0x0F      ; Blanco
    call imprimir_bios_color

    mov ah, 1
    int 21h
    cmp al, 'S'
    

    je inicio_programa
    cmp al, 's'

    je inicio_programa
    mov ah, 4Ch
    int 21h
    
; ----------------------------
; Subrutina: imprimir_bios_color
; Usa int 10h para imprimir cadena con color
; Entrada: DS:SI -> cadena terminada en '$', BL = color 

imprimir_bios_color:
    push ax
    push bx
    push cx
    push dx

    mov bh, 0         ; pagina de video
    xor dh, dh        ; fila = 0
    xor dl, dl        ; columna = 0
.next:
    lodsb
    cmp al, '$'
    je .end

    ; Imprimir el carácter con color
    mov ah, 09h
    mov cx, 1
    int 10h

    ; Avanzar el cursor (columna)
    inc dl
    mov ah, 02h        ; funcion: mover cursor
    int 10h

    jmp .next

.end:
    pop dx
    pop cx
    pop bx
    pop ax
    ret    
    
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
; Copia de SI a DI, eliminando espacios y pasando a minuscula

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
; Convierte AL a minuscula si es mayuscula 

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


limpiar_pantalla:
    mov ah, 06h         ; funcion: scroll up
    mov al, 0           ; número de líneas a desplazar (0 = limpiar toda la pantalla)
    mov bh, 07h         ; atributo: fondo negro, texto gris claro
    mov cx, 0           ; esquina superior izquierda (fila=0, col=0)
    mov dx, 184Fh       ; esquina inferior derecha (fila=24, col=79)
    int 10h
    ret

end main
