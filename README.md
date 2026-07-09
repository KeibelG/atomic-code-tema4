# Tema 4 - Análisis Léxico

### Equipo: **Atomic Code**
> _Segmentando el código, construyendo la lógica_

**Asignatura:** Lenguaje y Compiladores - 2026-I - Sección 01

**Universidad Nacional Experimental de Guayana (UNEG)**

---

## Integrantes

| Integrante | Cédula de Identidad |
|------------|---------------------|
| Victor Vargas | 30.697.219 |
| Keibel Guilarte | 28.726.605 |
| Oriana Márquez | 31.354.299 |
| Jeanny Monagas | 30.857.471 |

---

## Resumen del tema

El **Tema 4** aborda el **análisis léxico**: la primera fase de un compilador, encargada
de leer el programa fuente carácter a carácter y agruparlo en **tokens** (identificadores,
palabras reservadas, operadores, números, etc.), informando además si el programa
contiene errores léxicos. Se estudian dos formas de construir un analizador léxico
(lexer):

- **Desde cero**, escribiendo el autómata/expresiones regulares a mano.
- **Con un metacompilador** (en nuestro caso, **Flex**), que genera el programa lexer a
  partir de una descripción de patrones.

Este repositorio contiene los **dos casos prácticos con código funcional** exigidos por
la guía: un lexer para archivos **Dockerfile** hecho desde cero con expresiones
regulares en Python, y un lexer para un **subconjunto propio del lenguaje Rust**
construido con el metacompilador Flex.

---

## Estructura del repositorio

```
Tema 4 - Lenguajes y compiladores - Atomic Code/
├── README.md
├── Lexer-Dockerfile - Atomic Code/
│   ├── lexer_dockerfile.py     # Lexer desde cero (Python + regex)
│   ├── ejecutar.bat            # Corre los 3 ejemplos con doble clic
│   └── ejemplos/               # 3 Dockerfile de ejemplo
└── Lexer-Rust-Subset - Atomic Code/
    ├── lexer.l                 # Especificación Flex del lenguaje L
    ├── lex.yy.c                # Código C generado por Flex
    ├── lexer.exe               # Ejecutable ya compilado
    ├── Makefile                # flex + gcc en un solo comando
    ├── README.md                # Instalación y compilación del lexer
    ├── ejecutar.bat            # Corre los 3 ejemplos con doble clic
    └── ejemplos/               # 3 programas de ejemplo en L
```

### `Lexer-Dockerfile - Atomic Code/` - Lexer desde cero (Actividad 2)
Analizador léxico para archivos **Dockerfile**, escrito desde cero en Python con
expresiones regulares (sin librerías externas). Reconoce instrucciones (`FROM`, `RUN`,
`COPY`...), banderas, pares clave=valor, referencias de imagen, cadenas, números y
puertos. Además **verifica** el archivo: si la primera palabra de una línea no es una
instrucción válida (por ejemplo `FROMM` en vez de `FROM`), reporta un error léxico y
continúa leyendo el resto del archivo.

### `Lexer-Rust-Subset - Atomic Code/` - Lexer con metacompilador (Actividad 3)
Analizador léxico para **L**, un subconjunto propio del lenguaje Rust (funciones,
variables, condicionales, bucles, tipos básicos, comentarios, macro `println!`),
construido con el metacompilador **Flex**. Incluye el código C generado y el ejecutable
ya compilado, listos para correr.

---

## Requisitos

- **Python** 3.7 o superior para el lexer de Dockerfile. Verifica con `python --version`.
- **Flex** y **gcc** para el lexer de Rust. Ver instrucciones detalladas de instalación
  en `Lexer-Rust-Subset - Atomic Code/README.md`.

## Instalación y ejecución

1. Clona o descarga este repositorio y entra en la carpeta del proyecto:

   ```bash
   cd "Tema 4 - Lenguajes y compiladores - Atomic Code"
   ```

2. **Lexer de Dockerfile** (corre los 3 ejemplos):

   ```bash
   python "Lexer-Dockerfile - Atomic Code/lexer_dockerfile.py"
   ```

   O tokenizar un archivo puntual:

   ```bash
   python "Lexer-Dockerfile - Atomic Code/lexer_dockerfile.py" ruta/al/Dockerfile
   ```

3. **Lexer de Rust** (ya viene compilado; para volver a compilarlo hace falta flex + gcc):

   ```bash
   cd "Lexer-Rust-Subset - Atomic Code"
   make clean && make && make run
   ```

   O ejecutar directamente el binario ya incluido:

   ```bash
   ./lexer.exe ejemplos/ejemplo1.rs
   ```

En Windows, cada carpeta también incluye un `ejecutar.bat` para correr los 3 ejemplos
con doble clic, sin usar la terminal.

---

_Atomic Code - Segmentando el código, construyendo la lógica._
