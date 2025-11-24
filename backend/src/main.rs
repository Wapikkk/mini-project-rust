use axum::{routing::get, Json, Router};
use serde::Serialize;
use sysinfo::{RefreshKind, System, CpuRefreshKind, MemoryRefreshKind};
use std::sync::{Arc, Mutex};
use tokio::net::TcpListener;

#[derive(Serialize)]
struct ServerStatus {
    cpu_usage: f32,
    ram_used_mb: u64,
    ram_total_mb: u64,
}

struct AppState {
    sys: Mutex<System>,
}

#[tokio::main]
async fn main() {
    let sys = System::new_with_specifics(
        RefreshKind::new()
            .with_cpu(CpuRefreshKind::everything())
            .with_memory(MemoryRefreshKind::everything()),
    );

    let app_state = Arc::new(AppState { sys: Mutex::new(sys) });

    let app = Router::new()
        .route("/", get(get_status))
        .with_state(app_state);

    let listener = TcpListener::bind("0.0.0.0:3000").await.unwrap();
    println!("🚀 Server Rust berjalan di http://localhost:3000");
    axum::serve(listener, app).await.unwrap();
}

async fn get_status(axum::extract::State(state): axum::extract::State<Arc<AppState>>) -> Json<ServerStatus> {
    let mut sys = state.sys.lock().unwrap();
    sys.refresh_all();

    let cpu = sys.global_cpu_info().cpu_usage();
    let used = sys.used_memory() / 1024 / 1024;
    let total = sys.total_memory() / 1024 / 1024;

    Json(ServerStatus {
        cpu_usage: cpu,
        ram_used_mb: used,
        ram_total_mb: total,
    })
}
