//! Read-only FHIR access over MCP.
//!
//! Part of the `mcp` workspace, published in the registry as
//! `io.github.zarishhealth/fhir` and served at `POST /mcp` on the API. It exposes
//! search and read against the authenticated caller's authorisation, and nothing
//! that writes.
//!
//! Tool names are `snake_case`, domain-first, and at most 64 characters:
//! `fhir_search_resources`, `fhir_read_resource`. Each tool's input schema lives in
//! the `api` repository under `api/mcp/tools/`, and its input keys are `camelCase`.
//!
//! Patient data does not belong in a tool name, a URI, a header or a log line. The
//! implementation lands with the tasks that schedule the feature.
