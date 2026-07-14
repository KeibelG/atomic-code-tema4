@echo off
cd /d %~dp0
echo === ejemplo1.rs ===
.\lexer.exe ejemplos\ejemplo1.rs
echo.
echo === ejemplo2.rs ===
.\lexer.exe ejemplos\ejemplo2.rs
echo.
echo === ejemplo3.rs ===
.\lexer.exe ejemplos\ejemplo3.rs
pause
