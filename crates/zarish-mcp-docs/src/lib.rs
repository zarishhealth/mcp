//! Documentation search over MCP.
//!
//! Part of the `mcp` workspace, published in the registry as
//! `io.github.zarishhealth/docs` and served at `POST /mcp/docs`. It indexes the
//! published documentation for the `docs` site only — never a repository's private
//! notes, never a fixture, never patient data and never a secret.
//!
//! Tools are `snake_case` and domain-first, for example `docs_search_pages`. The
//! implementation lands with the tasks that schedule the feature.
