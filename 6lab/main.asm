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
	row		dd	1	; ����� ������
	len			dd	?	; ����� ������
	; ����� ��� ������
	buff		db	'    ', 512 dup(0)
	bytes		dd	?	; ���-�� ���� ������ ������
	
	hRead		dd	?	; ��������� �����
	hWrite		dd	?	; ����� ���������� ������
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
            
	; ��������� ���� in.txt �� ������
	invoke CreateFile, addr fin, GENERIC_READ, FILE_SHARE_READ , 0, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
	mov hRead, eax		; ��������� ��������� �����	
	; ������� ���� ��� ������
	invoke CreateFile, addr fout, GENERIC_WRITE, FILE_SHARE_WRITE , 0,CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
	mov hWrite, eax
	
	invoke WriteConsole, [hOut], addr msg, lengthof msg, addr bytes, NULL
	invoke ReadConsole, [hIn], addr subs, lengthof subs, addr bytes, NULL
	mov eax, [bytes]
	sub eax, 2
	mov [lensub], eax

@string:
	call	GetString	; ����� ������ �� �����
	; �������� � ������� ������
	cmp edi, offset buff + 4
	; ����� ���� �� ������� �� �����
	je	@exit
	; ����� ����� ������
	mov len, edi
	sub  len, offset buff 

	
	; ������� �� ������
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
	; �������� ����� ������
	invoke wsprintf, addr buff, addr fmt, row
	inc row	; ��������� ����� ������
	mov byte ptr [buff + eax], ' '
	; �������� ����� � ����
	invoke WriteFile, hWrite, addr buff,  len, addr bytes, NULL 
jmp @string
@exit:
	; ������� �����
	invoke CloseHandle, hRead
	invoke CloseHandle, hWrite
	invoke ExitProcess, 0

; ��������� ������ ����� �� �����
GetString	proc
	mov	edi, offset buff + 4
@read:
	; ������ 1 ����
	invoke ReadFile, hRead, edi, 1, addr bytes, NULL
	; ���� �� ������� ������ �� �����
	cmp bytes, 0
	je	@end		; ����� � ������
	; ���� crlf
	cmp byte ptr [edi], 0Ah
	je @crlf
	; ���� ����� ������
	cmp byte ptr [edi], 00h
	je @crlf
	; ����� ��������� � ��. ������ ������
	inc edi
jmp @read	; ���������� ������ ������
@end:
	; �������� � ������� ������
	cmp edi, offset buff + 4
	; ���� �����, ������ �� ���������
	je	@done
	; ����� ��������� ����� ������
	inc  edi
@crlf:
	; �������� ������ � ����� ������
	mov byte ptr [edi-1], ' '
	; ��������� ������� ������
	mov byte ptr [edi], 0Dh
	mov byte ptr [edi+1], 0Ah
	inc edi
@done:
	; ��������� �����
	mov byte ptr [edi + 1], 0
	ret
GetString endp
end Start