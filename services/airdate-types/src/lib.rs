use chrono::{DateTime, Utc};
use uuid::Uuid;
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
pub struct Bundle {
    pub id: Uuid,
    title: String,
    description: Option<String>,
    sources: Vec<Source>,
    ordering: Ordering
}

impl Bundle {
    pub fn new(title: String, description: Option<String>) -> Bundle {
        Bundle{
            id: Uuid::new_v4(),
            title,
            description,
            sources: vec![],
            ordering: Ordering::Airdate,
        }
    }

    pub fn add_source(&mut self, source: Source) {
        self.sources.push(source);
    }

    pub fn add_sources(&mut self, sources: Vec<Source>) {
        self.sources.extend(sources);
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub enum Source {
    TVDBSeries(String),
    TVDBEpisode(String),
    TraktSeries(String),
    TraktEpisode(String),
}

#[derive(Debug, Deserialize, Serialize)]
pub enum Ordering {
    Airdate,
    Bundle
}


pub struct Schedule {
    bundle: Bundle,
    elements: Vec<(DateTime<Utc>, Element)>
}

pub struct Element {
    id: Uuid,
    tvdb_id: String,
    title: String,
    airdate: DateTime<Utc>,
    watched: bool,
    source: Source
}