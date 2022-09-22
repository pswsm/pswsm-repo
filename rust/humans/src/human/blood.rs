use rand::thread_rng;

pub struct Blood {
  genotype: String,
  fenotype: String,
}

impl Blood {
    pub const fn new() -> Blood {
        Blood { genotype: String::new(), fenotype: String::new() }
    }
}

