use argon2::{
    password_hash::{PasswordHash, PasswordHasher, SaltString},
    Argon2, PasswordVerifier,
};
use rand::rngs::OsRng;

#[rustler::nif]
pub fn hash(password: String) -> Result<String, String> {
    let salt = SaltString::generate(&mut OsRng);
    let argon2 = Argon2::default();
    let hash = argon2.hash_password(password.as_bytes(), &salt);
    match hash {
        Ok(hash) => Ok(hash.to_string()),
        Err(_) => Err("Error hashing password".to_string()),
    }
}

#[rustler::nif]
pub fn verify(password: String, hash: String) -> Result<bool, String> {
    let banana = PasswordHash::new(&hash).unwrap();
    let argon2 = Argon2::default();
    let verification = argon2.verify_password(password.as_bytes(), &banana);
    match verification {
        Ok(_) => Ok(true),
        Err(_) => Err("Error verifying password".to_string()),
    }
}

rustler::init!("argon2id");
