use axum::{routing::post, Router, http::Method};
use enigo::{Enigo, Key, Settings, Keyboard, Direction};
use tower_http::cors::{Any, CorsLayer};

#[tokio::main]
async fn main() {
    let cors = CorsLayer::new()
        .allow_origin(Any)
        .allow_methods([Method::GET, Method::POST]);
    
    let app = Router::new()
        .route("/vol_up", post(volume_up))
        .route("/vol_down", post(volume_down))
        .route("/vol_mute", post(volume_mute))
        .route("/play_pause", post(play_pause))
        .layer(cors);
    
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    println!("Server Berjalan");

    axum::serve(listener, app).await.unwrap();
}

async fn volume_up() {
    println!("Volume Naik");
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    let _ = enigo.key(Key::VolumeUp, Direction::Click);
}

async fn volume_down() {
    println!("Volume Diturunkan");
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    let _ = enigo.key(Key::VolumeDown, Direction::Click);
}

async fn volume_mute() {
    println!("Volume Dimatikan");
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    let _ = enigo.key(Key::VolumeMute, Direction::Click);
}

async fn play_pause() {
    println!("Tombol Ditekan");
    let mut enigo = Enigo::new(&Settings::default()).unwrap();
    let _ = enigo.key(Key::MediaPlayPause, Direction::Click);
}