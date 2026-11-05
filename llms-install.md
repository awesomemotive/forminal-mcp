# Installing the Forminal MCP server

Forminal is a hosted, remote MCP server. There is nothing to download, build or run.

- URL: `https://app.forminal.ai/mcp`
- Transport: streamable HTTP
- Auth: OAuth 2.1 with dynamic client registration. The first call returns 401 with the protected-resource metadata, and the user signs in to Forminal (or creates an account) in the browser and allows access.

## Steps

1. Add the server to the MCP settings under the name `forminal`, with the URL above and streamable HTTP as the transport. For a client that uses an `mcpServers` map:

   ```json
   {
     "mcpServers": {
       "forminal": {
         "type": "streamableHttp",
         "url": "https://app.forminal.ai/mcp"
       }
     }
   }
   ```

   With the Cline CLI, the same thing in one line: `cline mcp add forminal https://app.forminal.ai/mcp --transport http --yes`

2. Connect. If the client supports OAuth, a browser tab opens for the user to sign in and allow access. In the Cline CLI, `cline mcp` has an Authorize OAuth action if no tab opens.
3. If the client can't do the browser sign-in, ask the user to create an API key in Forminal under **Account menu, Profile, API keys** (https://app.forminal.ai). Add it as a header, and keep it out of any file that's committed or shared:

   ```json
   {
     "mcpServers": {
       "forminal": {
         "type": "streamableHttp",
         "url": "https://app.forminal.ai/mcp",
         "headers": { "Authorization": "Bearer <the user's API key>" }
       }
     }
   }
   ```

4. Check it works by calling the `list_forms` tool. A new account answers with an empty list.

Then call `get_agent_instructions` before the first change: every write tool needs the `ack` code it returns. See the README for what the tools do.
