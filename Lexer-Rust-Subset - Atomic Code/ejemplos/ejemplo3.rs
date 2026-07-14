// Cuenta numeros pares y demuestra loop, break y continue
fn contar_pares(limite: i32) -> i32 {
    let mut contador: i32 = 0;
    let mut i: i32 = 0;
    loop {
        i = i + 1;
        if i > limite {
            break;
        }
        if i % 2 != 0 {
            continue;
        }
        contador = contador + 1;
    }
    return contador;
}

fn main() {
    let total: i32 = contar_pares(20);
    let letra: char = 'A';
    let mensaje: String = "conteo completado";
    println!("fin del programa");
}
