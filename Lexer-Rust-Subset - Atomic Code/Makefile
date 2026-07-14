CC = gcc
FLEX = flex

# En Windows, el make de MSYS2 no propaga TMP/TEMP a los procesos que lanza
# (gcc los necesita para archivos temporales); se exportan explicitamente
# para que no intente usar C:\WINDOWS (sin permiso de escritura).
export TMP
export TEMP

lexer: lex.yy.c
	$(CC) lex.yy.c -o lexer

lex.yy.c: lexer.l
	$(FLEX) -o lex.yy.c lexer.l

.PHONY: run clean

run: lexer
	./lexer ejemplos/ejemplo1.rs
	./lexer ejemplos/ejemplo2.rs
	./lexer ejemplos/ejemplo3.rs

clean:
	rm -f lex.yy.c lexer lexer.exe
