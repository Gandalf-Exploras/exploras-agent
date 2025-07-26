---
description: "Instructions for the exploras-agent workflow"
applyTo: [src/agent/generate_post.py, .github/workflows/blog.yml]
---

## Mission

Automate the generation and publishing of blog articles on exploras.cloud using AI and content from an epub file archived under ebook path. We use for example the ebook in epub format named 'Cloud-Native Ecosystems' 

## Detailed Workflow

1. **Receive user input:**  
   Prompt the user for a blog question or topic via command-line input (for now).
2. **Select chatmode:**  
   Load the appropriate chatmode file (default: `.github/chatmodes/oldbirba.chatmode.md`) and extract the system prompt and relevant metadata.
3. **Call OpenAI API:**  
   Use the loaded system prompt and the user’s question to generate a response using the GPT-4o model. Ensure API keys are loaded from environment variables or secrets.
4. **Format output:**  
   Structure the AI response as a Markdown article. Include front matter (title, date, tags, etc.) where appropriate. Always end with a call to action or invitation.
5. **Save locally:**  
   Save the article to an `output/` folder as a `.md` file with a timestamped filename.
6. **(Optional) Convert to HTML:**  
   If required, provide a function to convert Markdown to HTML (using a Python library).
7. **Stub: Publish to WordPress:**  
   Include a function stub for posting the article to WordPress via REST API, with parameters for authentication and draft/publish status.
8. **Logging and error handling:**  
   Log each major step. Handle API errors gracefully and provide meaningful messages to the user.
9. **Testing:**  
   Provide an automated test (`test_generate_post.py`) to simulate the full process with sample input and validate outputs.

## Constraints

- No secrets or API keys in code; always use environment variables or GitHub secrets.
- All outputs must be clear, structured, and end with a call to action.
- Handle errors gracefully; if OpenAI API fails, log and retry or notify admin.

## Personalization

- To change the writing style, edit the appropriate chatmode file in `.github/chatmodes/`.
- To add a new persona, create a new `.chatmode.md` file and update the workflow/script if needed.

---
description: "Detailed process instructions for exploras-agent: end-to-end blog generation and publishing."
applyTo: [src/agent/generate_post.py, .github/workflows/blog.yml]
---

## Mission





## Constraints

- Never store secrets in code or output files.
- All responses and files must be clear, well-structured, and safe to publish.
- Respect the writing style, tone, and constraints described in the selected chatmode.

## Personalization

- To update the writing style or persona, edit or create new `.chatmode.md` files in `.github/chatmodes/`.
- Update workflow or script logic as needed to support new personas or output formats.
