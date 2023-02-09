.386
.model flat, stdcall
option casemap:none

include kernel32.inc
include user32.inc
include msvcrt.inc
include windows.inc

includelib kernel32.lib
includelib user32.lib
includelib msvcrt.lib

.data
	fin			db	"in.txt", 0
	fout		db	"out.txt", 0
	
	fmt			db	'%d', 0
	row		dd	1	; номер строки
	len			dd	?	; длина строки
	; буфер дл€ строки
	buff		db	'    ', 512 dup(0)
	bytes		dd	?	; кол-во байт чтение записи
	
	hRead		dd	?	; описатель файла
	hWrite		dd	?	; адрес выделенной па€мти
	char		db	?
	
	subs		db	10 dup(0)
	lensub		dd	?
	
	msg		db	'input substring :', 0
	hIn			dd	?
	hOut		dd	?

.code
Start:
     invoke  GetStdHandle,-10
     mov     hIn, eax
      invoke  GetStdHandle,-11
     mov     hOut, eax
            
	; открываем файл in.txt на чтение
	invoke CreateFile, addr fin, GENERIC_READ, FILE_SHARE_READ , 0, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
	mov hRead, eax		; сохран€ем описатель файла	
	; создаем файл дл€ записи
	invoke CreateFile, addr fout, GENERIC_WRITE, FILE_SHARE_WRITE , 0,CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
	mov hWrite, eax
	
	invoke WriteConsole, [hOut], addr msg, lengthof msg, addr bytes, NULL
	invoke ReadConsole, [hIn], addr subs, lengthof subs, addr bytes, NULL
	mov eax, [bytes]
	sub eax, 2
	mov [lensub], eax

@string:
	call	GetString	; вз€ть строку из файла
	; сравнить с началом строки
	cmp edi, offset buff + 4
	; выход если не считали из файла
	je	@exit
	; найти длину строки
	mov len, edi
	sub  len, offset buff 

	
	; проходы по строке
	lea esi, buff
	mov ecx, [len]

@readstr:
	lea edi, subs
	lodsb
	dec ecx
	cmp ecx, 0
	je @write
	cmp al, [edi]
	jne @readstr
	mov ebx, esi
	dec ebx
	push ecx
	mov ecx, [lensub]
	dec ecx
@compare:	
	lodsb
	inc edi
	cmp al, [edi]
	je @compare
	sub esi, [lensub]
	mov edi, esi
	dec edi
	mov ecx, [lensub]
@change:
	mov al, ' '
	stosb
loop @change	
	pop ecx
jmp @readstr	
	
	
@write:
	; вставить номер строки
	invoke wsprintf, addr buff, addr fmt, row
	inc row	; увеличить номер строки
	mov byte ptr [buff + eax], ' '
	; записать текст в файл
	invoke WriteFile, hWrite, addr buff,  len, addr bytes, NULL 
jmp @string
@exit:
	; закрыть файлы
	invoke CloseHandle, hRead
	invoke CloseHandle, hWrite
	invoke ExitProcess, 0

; процедура чтени€ стоки из файла
GetString	proc
	mov	edi, offset buff + 4
@read:
	; читаем 1 байт
	invoke ReadFile, hRead, edi, 1, addr bytes, NULL
	; если не считали ничего из файла
	cmp bytes, 0
	je	@end		; пойти к выходу
	; если crlf
	cmp byte ptr [edi], 0Ah
	je @crlf
	; если конец строки
	cmp byte ptr [edi], 00h
	je @crlf
	; иначе сместитс€ к сл. €чейки буфера
	inc edi
jmp @read	; продолжать чтение строки
@end:
	; сравнить с началом строки
	cmp edi, offset buff + 4
	; если равны, чтени€ не произошло
	je	@done
	; иначе увеличить длину строки
	inc  edi
@crlf:
	; вставить пробел в конце строки
	mov byte ptr [edi-1], ' '
	; выставить перенос строки
	mov byte ptr [edi], 0Dh
	mov byte ptr [edi+1], 0Ah
	inc edi
@done:
	; закрываем нулем
	mov byte ptr [edi + 1], 0
	ret
GetString endp
end Start