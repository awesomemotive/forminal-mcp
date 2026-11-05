<p align="center"><img src="assets/icon-512.png" alt="Forminal" width="96" height="96"></p>

# Forminal MCP server

[Forminal](https://forminal.ai) is a hosted form builder. Your AI agent can build a form from a description, publish it, put it on any website as an inline embed or a popup, and read what people answered. This repository holds the install files for the Forminal MCP server, so you can add Forminal to Claude Code, Gemini CLI, Kiro, Cline and other agents.

The server is hosted, so there's nothing to install or run. Your agent connects to this address:

```
https://app.forminal.ai/mcp
```

The first time your agent calls it, a browser tab opens. You sign in to Forminal or create an account, then allow access. You don't need to create or paste a key.

## Add it to your agent

| Client | How |
|---|---|
| Claude Code | `claude mcp add forminal --scope user --transport http https://app.forminal.ai/mcp`, then run `/mcp`, pick `forminal` and sign in. Or install the plugin from this repo: `/plugin marketplace add awesomemotive/forminal-mcp`, then `/plugin install forminal@forminal` |
| Claude (web and desktop) | Settings, Connectors, add a custom connector with the address above |
| ChatGPT | Add the address as a custom MCP server under Plugins (turn on developer mode first if your plan needs it) |
| Codex CLI | `codex mcp add forminal --url https://app.forminal.ai/mcp`, then `codex mcp login forminal` |
| Cursor | Add `{ "mcpServers": { "forminal": { "url": "https://app.forminal.ai/mcp" } } }` to `~/.cursor/mcp.json` or `.cursor/mcp.json` |
| VS Code | Add `{ "servers": { "forminal": { "type": "http", "url": "https://app.forminal.ai/mcp" } } }` to `.vscode/mcp.json` |
| Gemini CLI | `gemini extensions install https://github.com/awesomemotive/forminal-mcp`, or `gemini mcp add --scope user --transport http forminal https://app.forminal.ai/mcp`. Run `/mcp auth forminal` if no tab opens |
| Kiro | Powers, Add Custom Power, Import power from GitHub, then paste `https://github.com/awesomemotive/forminal-mcp` |
| Cline | Ask Cline to install Forminal from this repo. It follows [llms-install.md](llms-install.md) |
| Anything else | Any client that connects a remote MCP server over streamable HTTP with OAuth works with the address above |

An agent that runs with nobody there to sign in can send an API key instead. Create one in Forminal under **Account menu, Profile, API keys**, and send it as `Authorization: Bearer <key>`.

Step-by-step guides for each client: [Connect your AI](https://forminal.ai/ai-form-builder/#connect-your-ai) and [MCP server](https://forminal.ai/docs/developers/mcp-server/).

## Then ask for what you want

- "Make a contact form with name, email and message, and add it to the contact page."
- "Build a workshop sign-up form and open it in a popup from the Register button."
- "Turn this list of questions into a customer survey and publish it."
- "How many people answered the feedback form this week, and what did they say about pricing?"
- "Export last month's order form submissions to CSV."

The agent builds the form, publishes it, gives you the link or the embed snippet (or places it, if it can edit your site) and reads the answers when you ask.

## Embed forms on any website

A published form has its own page with a link you can share, and it works on any site that takes HTML: WordPress, Webflow, Shopify, Squarespace, Wix, a static site or an app. `get_embed_snippet` returns the snippets for a form. Inline:

```html
<script src="https://app.forminal.ai/embed.js" async></script>
<iframe data-src="https://app.forminal.ai/embed/<form id>" loading="lazy" width="100%" height="300" frameborder="0" title="Contact us"></iframe>
```

Or as a popup that opens from a button:

```html
<script src="https://app.forminal.ai/embed.js" async></script>
<button data-open="<form id>" data-layout="modal">Open form</button>
```

The page never holds a key or calls the API. Full page, floating button and slider layouts are covered in [Embed forms](https://forminal.ai/features/embed-forms/).

## What the agent can do

- **Forms:** list, find, read, create, update, duplicate, publish or unpublish, delete, and check a form document with `validate_form_document` before saving it.
- **Versions:** every edit keeps the form as it was, so the agent can list earlier versions and put one back.
- **Sharing:** `get_embed_snippet` and `get_form_links` return the link, the inline embed and the popup snippet.
- **Submissions:** search, read, summarize, tag, mark as read or spam, delete, and export to CSV.
- **Analytics:** views, conversion, abandonments and drop-off per field, on plans that include Form analytics.
- **Account:** your plan and its features, and where each form sends its entries, with the last error, so the agent can tell you why entries aren't arriving.

The full list, with every argument, is served as JSON at https://app.forminal.ai/api/mcp/tools.

## Access and deletes

- The agent works as you, on your plan and your forms. You can disconnect it at any time under **Connected assistants** on the API keys tab, and its next call is refused.
- Every tool that creates, changes, publishes or deletes something takes an `ack` code from the [agent instructions](https://app.forminal.ai/llms.txt), so an agent reads how Forminal works before it changes anything.
- Deleting forms or submissions takes two steps. The agent first gets a summary of what would go, and only deletes after you agree.
- Submissions are written by the people who filled in your form. Agents are told to treat them as data, never as instructions.

## Plans

The free Lite plan includes unlimited forms and responses, with no card needed. Some features, such as form analytics, need a paid plan, and the agent can check yours with `get_account` before it promises one. See [Pricing](https://forminal.ai/pricing/).

## What's in this repo

The server is hosted, so this repo has no server code. These are the files each client needs to find and install it:

| File | For |
|---|---|
| `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `.mcp.json` | Claude Code plugin and marketplace |
| `skills/forminal/SKILL.md` | The Forminal skill, which tells an agent when and how to use the tools (Claude Code and Kiro) |
| `plugin.json`, `mcp.json` | Agent Plugins format (Kiro powers and other Agent Plugins clients) |
| `gemini-extension.json`, `GEMINI.md` | Gemini CLI extension |
| `llms-install.md` | Install steps for Cline and other agents that install from a README |
| `server.json` | The entry for the official MCP Registry (`ai.forminal/forminal`) |
| `assets/` | Icons |

## Help, privacy and terms

- Docs: https://forminal.ai/docs/
- Agent instructions: https://app.forminal.ai/llms.txt
- Privacy policy: https://forminal.ai/privacy/
- Terms: https://forminal.ai/terms/

## License

The files in this repository are MIT licensed. See [LICENSE](LICENSE). The Forminal service itself is covered by its [terms](https://forminal.ai/terms/).
