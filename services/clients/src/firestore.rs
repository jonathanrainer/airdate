use airdate_types::Bundle;
use firestore::errors::FirestoreError;
use firestore::FirestoreDb;
use thiserror::Error;

#[derive(Error, Debug)]
pub enum PersistenceError {
    #[error(transparent)]
    ConnectionError(#[from] FirestoreError)
}

pub trait FirestoreClient {

    fn insert_bundle(&self, bundle: Bundle) -> impl Future<Output = Result<Bundle, PersistenceError>> + Send;

}

#[derive(Clone)]
pub struct GoogleFirestoreClient {
    db: FirestoreDb
}

impl GoogleFirestoreClient {

    pub async fn new(project_id: String) -> Result<Self, PersistenceError> {
        Ok(GoogleFirestoreClient {
           db: FirestoreDb::new(project_id).await?
        })
    }

}

impl FirestoreClient for GoogleFirestoreClient {
    async fn insert_bundle(&self, bundle: Bundle) -> Result<Bundle, PersistenceError> {
        self.db.fluent().insert().into("bundles").document_id(bundle.id.to_string()).object(&bundle).execute::<Bundle>().await.map_err(PersistenceError::ConnectionError)
    }
}