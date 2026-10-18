# mcp

The Model Context Protocol servers the platform exposes: read-only FHIR access, code
lookup, and documentation search. `CATALOGUE.md` §3.8 has the layout;
`BLUEPRINT.md` §10 is the protocol rule and §10.1 the naming rule.

| Server | Registry name | Endpoint | Purpose |
| --- | --- | --- | --- |
| `zarish-mcp-fhir` | `io.github.zarishhealth/fhir` | `POST /mcp` | Search and read FHIR resources |
| `zarish-mcp-terminology` | `io.github.zarishhealth/terminology` | `POST /mcp/terminology` | Code lookup; no patient data |
| `zarish-mcp-docs` | `io.github.zarishhealth/docs` | `POST /mcp/docs` | Documentation search |

`zarish-mcp-core` holds the plumbing all three share.

## Protocol

The **stateless 2026-07-28 profile**, which is what this organization implements:

- One endpoint per server, `POST` only. No HTTP+SSE, no `Mcp-Session-Id`, no
  initialize handshake.
- The request headers `MCP-Protocol-Version`, `Mcp-Method` and `Mcp-Name` are
  required.
- Servers are **read-only by default**. A tool that changes data needs its own
  decision before it is written.

Tool names are `<domain>_<verb>_<noun>` in `snake_case` and at most 64 characters
(`fhir_search_resources`). Tool inputs are `camelCase` and their schemas live in the
`api` repository under `api/mcp/tools/`.

## Verify

```sh
scripts/check.sh                  # fmt, clippy, test, deny, naming, reuse, gitleaks
scripts/check.sh clippy test      # only the named checks
```

No workflow is committed: the checks run on the machine that made the change. A
check whose tool is missing is reported as skipped — never as passing.

## Not done yet

The three servers are empty crates that compile. They carry no dependencies and
expose no tools; that arrives with the MCP tasks. `servers/*.server.json` therefore
holds the registry name, version and description only — the transport block is added
when a server can actually answer, together with the registry schema URL it must
validate against.

## Rules

- **No patient data and no personal data** in a tool name, a resource URI, a header,
  a log line or a test fixture.
- Every tool is read-only unless a decision says otherwise.
- Identifiers are UUIDv7 and never derived from personal data.
