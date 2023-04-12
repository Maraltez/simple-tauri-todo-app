use rusqlite::{Connection, Result};

pub fn create_database()  -> Result<()>{
    let conn = Connection::open("test.db")?;

    conn.execute("DROP TABLE IF EXISTS todo",())?;

    conn.execute(
        "CREATE TABLE IF NOT EXISTS todo(
            id integer primary key

        )",
        (),
    )?;

    /*conn.execute(
        "INSERT INTO todo (id) VALUES (3)",
        ()
    )?;*/

    println!("{dir}/database.db",dir=tauri::api::path::BaseDirectory::AppData.variable());

    Ok(())
}

fn create_tables(conn: &Connection) -> Result<()>{
    conn.execute_batch(
        "BEGIN;
        CREATE TABLE IF NOT EXISTS todo
        "
    )


}




