#![cfg_attr(
  all(not(debug_assertions), target_os = "windows"),
  windows_subsystem = "windows"
)]

use tauri::api::path::{BaseDirectory, resolve_path};
use tauri::{generate_context, Manager};
use crate::database::get_database;

mod database;

fn main() {

  tauri::Builder::default()
      .setup(|app| {
          let path = resolve_path(
              &app.config(),
              app.package_info(),
              &app.env(),
              "todo.sqlite3",
              Some(BaseDirectory::AppLocalData)
          ).unwrap();

          get_database(path.as_path())?;

          Ok(())
      })
    .run(generate_context!())
    .expect("error while running tauri application");
}

