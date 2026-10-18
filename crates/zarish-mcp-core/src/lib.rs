//! Shared plumbing for the ZarishHealth MCP servers.
//!
//! Part of the `mcp` workspace. `CATALOGUE.md` section 3.8 says what this crate is
//! for; `BLUEPRINT.md` section 10 holds the protocol rules it has to implement:
//!
//! - The stateless 2026-07-28 Streamable HTTP profile: one endpoint, `POST` only,
//!   no `Mcp-Session-Id`, no initialize handshake.
//! - The required request headers `MCP-Protocol-Version`, `Mcp-Method` and
//!   `Mcp-Name`.
//! - Servers are read-only by default; a tool that changes data is the exception
//!   and needs its own decision.
//!
//! The implementation lands with the tasks that schedule the feature.
