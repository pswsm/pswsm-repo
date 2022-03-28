use std::fmt;

#[derive(Debug)]
struct Human {
  fname: String,
  lname: String,
  age: u64,
  blood_type: Blood,
}

#[derive(Debug)]
struct Blood {
  genotype: String,
  fenotype: String,
}

impl Human {
  fn make_human(fname: String, lname: String, age: u64, blood_type: Blood) -> Human {
    Human {
      fname,
      lname,
      age,
      blood_type,
    }
  }
}

impl Blood {
  fn make_blood(genotype: String, fenotype: String) -> Blood {
    Blood {
      genotype,
      fenotype,
    }
  }
}

impl fmt::Display for Blood {
  fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
    write!(f, "Genotype: {}\nFenotype: {}", self.genotype, self.fenotype)
  }
}

impl fmt::Display for Human {
  fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
    write!(f, "Name {} {}\nAge: {}\nBlood Group: {}", self.fname, self.lname, self.age, self.blood_type.fenotype)
  }
}

fn main() {
  let human_test: Human = Human::make_human(String::from("Pau"), String::from("Figueras"), 18, Blood::make_blood(String::from("aa"), String::from("A")));
  println!("{}", human_test);
}
