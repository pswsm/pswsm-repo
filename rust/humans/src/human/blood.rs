use rand::thread_rng;

pub struct Blood {
  genotype: String,
  fenotype: String,
}

impl Blood {
  pub fn select_genotype(self) -> None {
    let mut rng = rand::thread_rng.thread_rng();
    let y: i8 = rng.gen_range(0, 6);
    self.genotype = self.possibleGenotypes[y];
  }
}

