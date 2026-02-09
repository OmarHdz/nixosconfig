
# Sesion
https://geminicli.com/docs/cli/cli-reference/
gemini -r "latest"	Continue most recent session	gemini -r "latest"
gemini -r "latest" "query"	Continue session with a new prompt	gemini -r "latest" "Check for type errors"
gemini -r "<session-id>" "query"	Resume session by ID	gemini -r "abc123" "Finish this PR"
gemini update	Update to latest version	gemini update
gemini extensions	Manage extensions	See Extensions Management
gemini mcp	Configure MCP servers	See MCP Server Management

## List sessions
gemini --list-sessions

--resume	-r	string	-	Resume a previous session. Use "latest" for most recent or index number (e.g. --resume 5)
--list-sessions	-	boolean	-	List available sessions for the current project and exit
--delete-session	-	string	-	Delete a session by index number (use --list-sessions to see available sessions)
--include-directories	-	array	-	Additional directories to include in the workspace (comma-separated or multiple flags)
--screen-reader	-	boolean	-	Enable screen reader mode for accessibility
--output-format	-o	string	text	The format of the CLI output. Choices: text, json, stream-json

# Comandos cli

## Chat
Description: Save and resume conversation history for branching conversation state interactively, or resuming a previous state from a later session.

Sub-commands:
- delete <tag> - Description: Deletes a saved conversation checkpoint.
- list - Description: Lists available tags for chat state resumption.
Note: This command only lists chats saved within the current project. Because chat history is project-scoped, chats saved in other project directories will not be displayed.
- resume <tag> - Description: Resumes a conversation from a previous save.
Note: You can only resume chats that were saved within the current project. To resume a chat from a different project, you must run the Gemini CLI from that project’s directory.
- save <tag> - Description: Saves the current conversation history. You must add a <tag> for identifying the conversation state.
Details on checkpoint location: The default locations for saved chat checkpoints are:
Linux/macOS: ~/.gemini/tmp/<project_hash>/
Windows: C:\Users\<YourUsername>\.gemini\tmp\<project_hash>\
Behavior: Chats are saved into a project-specific directory, determined by where you run the CLI. Consequently, saved chats are only accessible when working within that same project.
Note: These checkpoints are for manually saving and resuming conversation states. For automatic checkpoints created before file modifications, see the Checkpointing documentation.
- share [filename] - Description Writes the current conversation to a provided Markdown or JSON file. If no filename is provided, then the CLI will generate one.
Usage /chat share file.md or /chat share file.json.

## Compress
/compress - Description: Replace the entire chat context with a summary. This saves on tokens used for future tasks while retaining a high level summary of what has happened.

## Copy
/copy - Description: Copies the last output produced by Gemini CLI to your clipboard, for easy sharing or reuse.

## Directory
/directory (o /dir)

## Ext
/extensions - Description: Lists all active extensions in the current Gemini CLI session. See Gemini CLI Extensions.ensions

## Init
/init - Description: To help users easily create a GEMINI.md file, this command analyzes the current directory and generates a tailored context file, making it simpler for them to provide project-specific instructions to the Gemini agent.

# Custom Commands
File locations and precedence
Gemini CLI discovers commands from two locations, loaded in a specific order:

User commands (global): Located in ~/.gemini/commands/. These commands are available in any project you are working on.
Project commands (local): Located in <your-project-root>/.gemini/commands/. These commands are specific to the current project and can be checked into version control to be shared with your team.
If a command in the project directory has the same name as a command in the user directory, the project command will always be used. This allows projects to override global commands with project-specific versions.





