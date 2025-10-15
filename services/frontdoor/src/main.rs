mod errors;

use axum::{Json, Router};
use axum::extract::{Path, State};
use axum::http::StatusCode;
use axum::routing::{get, post};
use axum_macros::debug_handler;
use chrono::{NaiveDate, Utc};
use serde::Deserialize;
use tracing::info;

use airdate_types::{Bundle, Source};
use clients::firestore::{FirestoreClient, GoogleFirestoreClient};
use crate::errors::Error;
use crate::errors::Error::MissingProjectId;

#[tokio::main]
async fn main() -> Result<(), Error> {
    tracing_subscriber::fmt::init();

     let client = if let Ok(project_id) = std::env::var("GOOGLE_PROJECT_ID") {
         GoogleFirestoreClient::new(project_id).await?
     } else {
         return Err(MissingProjectId)
     };


    let app = Router::new()
        .route("/bundle", post(create_bundle))
        .route("/schedule", get(get_todays_schedule))
        .route("/schedule/{date}", get(get_specific_schedule))
        .with_state(AppState{ firestore_client: client });

    // run our app with hyper, listening globally on port 3000
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    info!("Web server started on http://0.0.0.0:3000");
    Ok(axum::serve(listener, app).await?)
}

#[derive(Clone)]
struct AppState {
    firestore_client: GoogleFirestoreClient
}

#[derive(Deserialize)]
struct CreateBundle {
    title: String,
    description: Option<String>,
    sources: Vec<Source>,
    ordering: String
}

#[debug_handler]
async fn create_bundle(State(state): State<AppState>, Json(payload): Json<CreateBundle>) -> (StatusCode, String) {
    let mut b = Bundle::new(payload.title, payload.description);
    b.add_sources(payload.sources);
    match state.firestore_client.insert_bundle(b).await {
        Ok(b) => (StatusCode::CREATED, format!("Created bundle {}", b.id)),
        Err(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string())
    }
}

async fn get_todays_schedule() {
    info!("Getting today's schedule");
    get_schedule(Utc::now().date_naive())
}

async fn get_specific_schedule(Path(date): Path<NaiveDate>) {
    info!("Getting schedule for '{}'", date);
    get_schedule(date)
}

fn get_schedule(date: NaiveDate) {
    info!("Beginning schedule retrival for date '{}'", date);
}