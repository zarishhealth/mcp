# AGENTS.md — mcp

**Scope:** this repository. The workspace rules are in
`/home/healthbgd/zarishhealth/GOVERNANCE.md`; where the two disagree, the stricter
rule wins. `CATALOGUE.md` §3.8 has the layout, `BLUEPRINT.md` §10 the protocol and
naming rules.

## Verify

```sh
scripts/check.sh                  # fmt, clippy, test, deny, naming, reuse, gitleaks
scripts/check.sh clippy test      # only the named checks
```

No workflow is committed. A check whose tool is missing is reported as skipped —
never as passing.

## Cautions

- **Read-only by default.** A tool that writes needs a decision first; never add one
  because it is convenient.
- This is the stateless 2026-07-28 profile: no session id, no initialize handshake,
  and `MCP-Protocol-Version`, `Mcp-Method` and `Mcp-Name` are required on every
  request. Do not implement the older stateful shape.
- **No patient data and no personal data** anywhere: not in a tool name, a resource
  URI, a header, a log line or a fixture.
- Tool names are `snake_case` and domain-first, `<domain>_<verb>_<noun>`, at most 64
  characters; tool inputs are `camelCase`.
- The registry name is `io.github.zarishhealth/<domain>` — the organization's GitHub
  namespace, not a domain the organization owns.
