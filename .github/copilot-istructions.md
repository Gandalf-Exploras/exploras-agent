# Copilot Repository Instructions

Welcome to `exploras-agent`, an open-source agent for generating and publishing cloud-native blog articles.

## General Guidelines

- All code and documentation must be clear, readable, and well-commented.
- Use PEP8 style for Python code.
- All strings and comments in English, unless otherwise specified.
- Always add descriptive docstrings to all functions and classes.
- Use Markdown for documentation files.

## AI Usage

- Use the AI system prompt stored in `.github/chatmodes/oldbirba.blogmode.md` for content generation.
- Scripts must not hardcode API keys; always use environment variables or GitHub secrets.
- Any workflow involving publishing must first save a Markdown draft before API calls.

## Output Style

- Blog articles should be accessible to both technical and non-technical readers.
- Prefer an engaging, narrative tone as in the book "Exploring Cloud-Native Ecosystems".
- Each blog post should end with a call to action or an invitation to explore more.

## Security

- Never commit secrets or private data in the repository.
- Handle all configuration values via secrets or environment variables.
