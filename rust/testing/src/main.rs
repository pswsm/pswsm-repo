extern crate rand;
// use rand::prelude::*;
use rand::seq::SliceRandom;
use std::fmt;

struct Human {
    fname: String,
    lname: String,
    age: u64,
    blood_type: Blood,
}

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
    let possible_first_names = [String::from("Pau"), String::from("Denys"), String::from("Victor"), String::from("Gabriel"), String::from("Luis")];
    let possible_last_names = [String::from("Figueras"), String::from("Pavón"), String::from("Pablo"), String::from("Tugas"), String::from("Comas")];
  
    let selected_first_name: String = String::from(possible_first_names.choose(&mut rand::thread_rng()).unwrap());
    let selected_last_name: String = String::from(possible_last_names.choose(&mut rand::thread_rng()).unwrap());

    let human_test: Human = Human::make_human(selected_first_name, selected_last_name, 18, Blood::make_blood(String::from("aa"), String::from("A")));
    println!("{}", human_test);
}
