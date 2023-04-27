use std::fs::File;
use std::io::Read;
use std::path::{Path, PathBuf};
use std::sync::Mutex;
use lazy_static::lazy_static;
use rusqlite::{Connection, Result};
use tauri::api::path::{BaseDirectory, resolve_path};
use tauri::{Assets, Context, Env};

lazy_static! {
    static ref DB_CONNECTION: Mutex<Option<Connection>> = Mutex::new(None);
}

pub fn get_database(path: &Path) -> Result<()>{

    let path_exists = Path::new(&path).exists();

    let mut conn = DB_CONNECTION.lock().unwrap();

    *conn = Some(Connection::open(&path)?);

    if !path_exists{
        create_database(conn.as_ref().unwrap()).expect("TODO: panic message");
    }

    Ok(())
}

fn create_database(conn: &Connection) -> Result<()>{
    let mut file = File::open("./src/database/db_creation.sql").expect("File not found");
    let mut data = String::from("");

    file.read_to_string(&mut data).expect("Test");

    println!("{}", data);

    conn.execute_batch(&*data)?;

    Ok(())
}

//fn add_user()






