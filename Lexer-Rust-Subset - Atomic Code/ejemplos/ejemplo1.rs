// Calcula el factorial de un numero de forma iterativa
fn factorial(n: i32) -> i32 {
    let mut resultado: i32 = 1;
    let mut i: i32 = 1;
    while i <= n {
        resultado = resultado * i;
        i = i + 1;
    }
    return resultado;
}

fn main() {
    let n: i32 = 5;
    let r: i32 = factorial(n);
    println!("el factorial fue calculado");
}
