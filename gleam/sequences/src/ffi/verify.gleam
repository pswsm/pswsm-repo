@external(erlang, "argon2id", "verify")
pub fn verify(password p: String, hash h: String) -> Result(Bool, String)
