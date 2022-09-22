pub mod blood;

pub struct Human {
    blood_type: blood::Blood,
    first_name: String,
    last_name: String,
    natural_age: u8,
    biologic_age: u8,
}
