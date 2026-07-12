# Lenguaje:   Python 3
# Asignatura: Lenguajes y compiladores
# Equipo:     Atomic Code
#             Segmentando el código, construyendo la lógica
#
# Integrantes:
#   - Victor Vargas    C.I: 30.697.219
#   - Keibel Guilarte  C.I: 28.726.605
#   - Oriana Márquez   C.I: 31.354.299
#   - Jeanny Monagas   C.I: 30.857.471
#
# ---------------------------------------------------------------------------
#                           DESCRIPCIÓN
# ---------------------------------------------------------------------------
# Analizador léxico (lexer) construido desde cero en Python con expresiones
# regulares (módulo re) para el lenguaje L = sintaxis de un Dockerfile.
#
# Componentes léxicos reconocidos:
#   INSTRUCTION  -> FROM, RUN, CMD, COPY, ADD, ENV, ARG, EXPOSE, WORKDIR, ...
#                   (solo al inicio de una línea lógica)
#   FLAG         -> --opcion  o  --opcion=valor      (ej: --from=builder)
#   KEYVALUE     -> identificador=valor               (ej: NODE_ENV=production)
#   IMAGE_REF    -> nombre:tag  o  nombre@sha256:hash (ej: node:18-alpine)
#   STRING       -> literal entre comillas simples o dobles
#   NUMBER       -> numero(/tcp|/udp)?                (ej: 8080/tcp, 3000, 1000)
#   PUNCT        -> [ ] ,                             (arreglos JSON de CMD/ENTRYPOINT)
#   IDENTIFIER   -> cualquier otro token no separado por espacios (rutas, comandos, args)
#   COMMENT      -> línea que inicia con #  (se ignora, no se produce token)
#   SKIP         -> espacios y tabuladores (se ignoran)
#   NEWLINE      -> salto de línea (solo cuenta línea, no se produce token)
#   MISMATCH     -> cualquier carácter no reconocido por las reglas anteriores
#
# Verificación léxica (informa si P tiene errores léxicos, como pide la guía):
# el cuerpo de las instrucciones (RUN, argumentos, rutas, flags de shell como
# "&&") es texto libre y no se restringe, pero el PRIMER token de cada línea
# lógica SÍ es una gramática cerrada (siempre debe ser una instrucción válida
# de Dockerfile). Por eso, si esa primera palabra no es una instrucción
# reconocida (ej. "FROMM" en vez de "FROM"), el lexer reporta un ERROR LÉXICO
# y continúa con la siguiente línea, en vez de detenerse (mismo criterio de
# "estados fallidos" que resiliencia descrito en la guía).
#
# Nota de simplificación: las líneas terminadas en "\" (continuación de línea)
# se unen en una sola línea lógica ANTES de tokenizar; por eso el número de
# línea reportado es el de la línea lógica resultante, no el de la línea física
# original del archivo.
#
# Uso:
#   python lexer_dockerfile.py               # corre los 3 ejemplos de ejemplos/
#   python lexer_dockerfile.py archivo       # tokeniza un Dockerfile puntual
# ---------------------------------------------------------------------------

import re
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

# ===========================================================================
#           1) UNIÓN DE LÍNEAS CONTINUADAS (backslash + salto de línea)
# ===========================================================================
RE_CONTINUACION = re.compile(r"\\[ \t]*\r?\n[ \t]*")


def unir_continuaciones(texto):
    """Reemplaza 'barra invertida + fin de línea' por un solo espacio, de modo
    que una instrucción partida en varias líneas físicas se vea como una sola
    línea lógica para el tokenizador."""
    return RE_CONTINUACION.sub(" ", texto)


# ===========================================================================
#           2) DEFINICIÓN DE TOKENS (expresión regular por componente léxico)
# ===========================================================================
INSTRUCCIONES = (
    r"FROM|RUN|CMD|LABEL|EXPOSE|ENV|ADD|COPY|ENTRYPOINT|VOLUME|USER|"
    r"WORKDIR|ARG|ONBUILD|STOPSIGNAL|HEALTHCHECK|SHELL|MAINTAINER"
)

TOKENS = [
    ("NEWLINE",     r"\r?\n"),
    ("SKIP",        r"[ \t]+"),
    ("COMMENT",     r"#.*"),
    ("INSTRUCTION", rf"^(?:{INSTRUCCIONES})\b"),
    ("UNKNOWN_INSTRUCTION", r"^[A-Za-z][A-Za-z0-9_-]*"),
    ("FLAG",        r"--[A-Za-z][A-Za-z0-9_-]*(?:=\S+)?"),
    ("STRING",      r'"(?:[^"\\]|\\.)*"' + r"|'(?:[^'\\]|\\.)*'"),
    ("IMAGE_REF",   r"[\w./-]+(?::[\w.-]+|@sha256:[0-9a-fA-F]+)"),
    ("NUMBER",      r"\d+(?:/(?:tcp|udp))?\b"),
    ("KEYVALUE",    r'[A-Za-z_][A-Za-z0-9_]*=(?:"(?:[^"\\]|\\.)*"' + r"|'(?:[^'\\]|\\.)*'|\S+)"),
    ("PUNCT",       r"[\[\],]"),
    ("IDENTIFIER",  r"[^\s]+"),
    ("MISMATCH",    r"."),
]

TOKEN_REGEX = re.compile(
    "|".join(f"(?P<{nombre}>{patron})" for nombre, patron in TOKENS),
    re.MULTILINE | re.IGNORECASE,
)


# ===========================================================================
#           3) MOTOR DEL LEXER
# ===========================================================================
def lexer(texto):
    """Generador de tokens: (tipo, valor, línea, columna). El tipo ERROR
    (columna en None) señala una instrucción de Dockerfile no reconocida;
    quien consuma el generador decide cómo mostrarlo, el lexer en sí no
    imprime nada."""
    texto = unir_continuaciones(texto)
    linea = 1
    inicio_linea = 0

    for mo in TOKEN_REGEX.finditer(texto):
        tipo = mo.lastgroup
        valor = mo.group(tipo)

        if tipo == "NEWLINE":
            linea += 1
            inicio_linea = mo.end()
            continue
        if tipo in ("SKIP", "COMMENT"):
            continue
        if tipo == "UNKNOWN_INSTRUCTION":
            yield "ERROR", f"instrucción de Dockerfile no reconocida {valor!r}", linea, None
            continue
        if tipo == "MISMATCH":
            raise RuntimeError(f"Carácter no reconocido {valor!r} en la línea {linea}")

        columna = mo.start() - inicio_linea
        yield tipo, valor, linea, columna


# ===========================================================================
#           4) EJECUCIÓN: TOKENIZA LOS 3 DOCKERFILE DE EJEMPLO
# ===========================================================================
BASE = Path(__file__).parent
EJEMPLOS = [
    BASE / "ejemplos" / "ejemplo1.dockerfile",
    BASE / "ejemplos" / "ejemplo2.dockerfile",
    BASE / "ejemplos" / "ejemplo3.dockerfile",
]


def tokenizar_archivo(ruta):
    print("===========================================================")
    print(f" Archivo: {ruta.name}")
    print("===========================================================")
    texto = ruta.read_text(encoding="utf-8")
    for tipo, valor, linea, columna in lexer(texto):
        if tipo == "ERROR":
            print(f"  ERROR LÉXICO: {valor} en la línea {linea}")
        else:
            print(f"  ({tipo:<11s}, {valor!r:<28s}, línea {linea}, columna {columna})")
    print()


def ejecutar():
    if len(sys.argv) > 1:
        tokenizar_archivo(Path(sys.argv[1]))
        return
    for ruta in EJEMPLOS:
        tokenizar_archivo(ruta)


if __name__ == "__main__":
    ejecutar()
