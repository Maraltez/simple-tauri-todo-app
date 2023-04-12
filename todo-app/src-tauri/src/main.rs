#![cfg_attr(
  all(not(debug_assertions), target_os = "windows"),
  windows_subsystem = "windows"
)]

mod database;

fn main() {
  database::create_database().expect("TODO: panic message");
  
  /*tauri::Builder::default()
    .run(tauri::generate_context!())
    .expect("error while running tauri application");*/
}

