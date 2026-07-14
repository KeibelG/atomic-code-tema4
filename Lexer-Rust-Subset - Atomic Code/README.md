# Lexer subconjunto de Rust (Flex)

## Instalación

Se necesita `flex` y un compilador de C (`gcc`).

- **Windows (MSYS2):**
  ```
  pacman -S --needed flex
  ```
  (usar una terminal MSYS2/MinGW64 con `gcc` ya disponible)
- **Windows (WSL) / Linux (Debian/Ubuntu):**
  ```
  sudo apt install flex gcc
  ```
- **macOS:**
  ```
  brew install flex
  ```

Verificar instalación:
```
flex --version
gcc --version
```

## Compilar

```
flex -o lex.yy.c lexer.l
gcc lex.yy.c -o lexer
```

O con el Makefile incluido:
```
make
```

## Ejecutar

```
./lexer ejemplos/ejemplo1.rs
./lexer ejemplos/ejemplo2.rs
./lexer ejemplos/ejemplo3.rs
```

O todos de una vez:
```
make run
```

## Limpiar archivos generados

```
make clean
```
