
# Copilot Repository Instructions

Welcome to `exploras-agent`, an open-source AI agent for extracting knowledge and generating articles and answers from any epub book with a Table of Contents (TOC).

## General Guidelines

- All code and documentation must be clear, readable, and well-commented.
- Use PEP8 style for Python code.
- All strings and comments in English, unless otherwise specified.
- Always add descriptive docstrings to all functions and classes.
- Use Markdown for documentation files.

## AI Usage

- Use the AI system prompt stored in `.github/chatmodes/oldbirba.chatmode.md` (or other persona files) for content generation. This allows for flexible style and persona customization.
- Scripts must not hardcode API keys; always use environment variables or GitHub secrets.
- Any workflow involving publishing must first save a Markdown draft before API calls.

## Output Style

- Articles and answers should be accessible to both technical and non-technical readers.
- Prefer an engaging, narrative tone (customizable via chatmode files).
- Each output should end with a call to action or an invitation to explore more.

## Security

- Never commit secrets or private data in the repository.
- Handle all configuration values via secrets or environment variables.
## Supported Content

- The system works with any epub file that contains a Table of Contents (TOC).
- The provided example uses "Cloud-Native Ecosystems", but you can upload and use any epub.
