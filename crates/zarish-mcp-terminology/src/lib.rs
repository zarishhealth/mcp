//! Code lookup over the local terminology data, exposed over MCP.
//!
//! Part of the `mcp` workspace, published in the registry as
//! `io.github.zarishhealth/terminology` and served at `POST /mcp/terminology`.
//!
//! This server answers "what does this code mean", never "who is this person": it
//! carries no patient data and no personal data, and its resource URIs are of the
//! form `zarish://terminology/<system>/<code>`. Tools are `snake_case` and
//! domain-first, for example `terminology_lookup_code`.
//!
//! The implementation lands with the tasks that schedule the feature.
