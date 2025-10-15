use thiserror::Error;
use clients::firestore::PersistenceError;

#[derive(Error, Debug)]
pub enum Error {
    #[error("GOOGLE_PROJECT_ID is missing, this is a required environment variable")]
    MissingProjectId,
    #[error("Could not establish database connection")]
    DatabaseConnectionError(#[from] PersistenceError),
    #[error("Axum error")]
    AxumError(#[from] std::io::Error)
}