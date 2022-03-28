extern crate rand;

struct Blood {
  genotype: String,
  fenotype: String,
  let possibleGenotypes: [String; 6] = ["aa", "bb", "ab", "ao", "bo", "oo"],
}

struct Human {
  bloodType: Blood,
  firstName: String,
  lastName: String,
  naturalAge: u8,
  biologicAge: u8 
}

impl Blood {
  fn selectgenotype(self) -> None {
    let mut rng = rand::thread_rng.thread_rng();
    let y: i8 = rng.gen_range(0, 6);
    self.genotype = self.possibleGenotypes[y];
  }
}

fn main() {
  bloodtest: Blood = bloodtest.selectgenotype();
  println!("{}", bloodtest);
}
