/* Verifica si un numero es primo
   usando un bucle con condicionales */
fn es_primo(n: i32) -> bool {
    if n < 2 {
        return false;
    }
    let mut i: i32 = 2;
    while i < n {
        if n % i == 0 {
            return false;
        }
        i = i + 1;
    }
    return true;
}

fn main() {
    let numero: i32 = 17;
    let primo: bool = es_primo(numero);
    if primo {
        println!("es primo");
    } else {
        println!("no es primo");
    }
}
