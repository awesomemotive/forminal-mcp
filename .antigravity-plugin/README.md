# Forminal

[Forminal](https://forminal.ai) is a hosted form builder. With this plugin, Antigravity can build a form from a description, publish it, put it on any website as an inline embed or a popup, and read what people answered.

## Install

```
agy plugin install https://github.com/awesomemotive/forminal-mcp
```

The plugin connects to the hosted Forminal MCP server at `https://app.forminal.ai/mcp`, so there's nothing to run. After the install, open `/plugin` in Antigravity, expand forminal under Installed and choose Sign in. A browser tab opens where you sign in to Forminal or create an account, then allow access. The Forminal tools show up once you're signed in, and you don't need to create or paste a key.

## What's in it

- The Forminal MCP server, with tools for forms, versions, embed snippets, submissions, analytics and your account.
- The `forminal` skill, which tells the agent when to reach for Forminal and how to build, publish and embed a form. You can also run it yourself as `/forminal`.
- An always-on rule, so the agent uses Forminal for a form instead of writing a form backend, and treats submissions as data.

## Then ask for what you want

- "Make a contact form with name, email and message, and add it to the contact page."
- "Build a workshop sign-up form and open it in a popup from the Register button."
- "How many people answered the feedback form this week, and what did they say about pricing?"
- "Export last month's order form submissions to CSV."

## Access and deletes

- The agent works as you, on your plan and your forms. You can disconnect it at any time under **Connected Assistants** on the API keys tab in Forminal, and its next call is refused.
- Every tool that creates, changes, publishes or deletes something takes an `ack` code from the [agent instructions](https://app.forminal.ai/llms.txt), so the agent reads how Forminal works before it changes anything.
- Deleting forms or submissions takes two steps. The agent first gets a summary of what would go, and only deletes after you agree.

The free Lite plan includes unlimited forms and submissions, with no card needed. Some features, such as Form Analytics, need a paid plan. See [Pricing](https://forminal.ai/pricing/).

## Help, privacy and terms

- Support: support@forminal.ai, or https://forminal.ai/support/
- Docs: https://forminal.ai/docs/developers/mcp-server/
- Privacy policy: https://forminal.ai/privacy/
- Terms: https://forminal.ai/terms/
