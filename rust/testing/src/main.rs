extern crate rand;
// use rand::prelude::*;
use rand::seq::SliceRandom;
use std::fmt;
use crate::rand::Rng;
use std::vec;

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

fn select_rnd_str(string_list: Vec<String>) -> String {
    let selected_string: String = String::from(string_list.choose(&mut rand::thread_rng()).unwrap());
    selected_string
}

fn select_rnd_int(max_number: u64) -> u64 {
    let selected_uint: u64 = rand::thread_rng().gen_range(0..=max_number);
    selected_uint
}

fn main() {
    let possible_first_names: Vec<String> = vec![String::from("Pau"), String::from("Denys"), String::from("Victor"), String::from("Gabriel"), String::from("Luis")];
    let possible_last_names: Vec<String> = vec![String::from("Figueras"), String::from("Pavón"), String::from("Pablo"), String::from("Tugas"), String::from("Comas")];
    let possible_genotypes: Vec<String> = vec![String::from("aa"), String::from("ab"), String::from("ao"), String::from("bb"), String::from("bo"), String::from("oo")];
  
    let human_test: Human = Human::make_human(select_rnd_str(possible_first_names), select_rnd_str(possible_last_names), select_rnd_int(90), Blood::make_blood(select_rnd_str(possible_genotypes), String::from("A")));
    println!("{}", human_test);
}
