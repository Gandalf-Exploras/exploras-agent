
# Copilot Instructions for Exploras-Agent

**This is an AI-generated experimental prototype** for validating UX workflows and cost optimization when extracting knowledge from epub books.

## Core Use Case & Architecture

**Primary Goal**: Reduce OpenAI costs by sending only relevant book sections instead of entire content.

**Workflow**:
1. User uploads epub → System extracts TOC (2 levels max)
2. UI presents hierarchical TOC tree → User selects specific section  
3. User asks question → System sends only selected TOC section content to ChatGPT
4. AI generates contextual answer → Display in UI

**3-tier experimental system**:
- **Frontend**: Angular + Material UI (blue/orange theme) for TOC selection and Q&A
- **Backend**: Python FastAPI serving TOC data and targeted content extraction
- **Content Engine**: Uses `ebooklib` for epub parsing + GPT-4o for targeted responses

**Cost Optimization Strategy**: Only the selected TOC section content is sent to OpenAI, not the entire book.

## Essential Development Patterns

### EPUB Processing (Core Pattern)
```python
# samples/extract_epub_toc.py demonstrates the TOC extraction:
from ebooklib import epub
book = epub.read_epub('ebook/[any-epub-file].epub')
toc = book.toc  # Hierarchical TOC structure

# Next step: Extract content for specific TOC sections only
def get_toc_content(book, selected_toc_item):
    # Implementation needed: extract only relevant chapter/section content
    pass
```
- TOC extraction supports **2 levels maximum** (level 1 & 2 titles only)
- **Critical**: Need content extraction by TOC selection (not implemented yet)
- All epub files go in `ebook/` directory

### AI Persona System (Critical)
```markdown
# .github/chatmodes/[persona].chatmode.md structure:
---
description: 'Persona description'
model: GPT-4o
title: 'Persona Name'  
---
## System Prompt
[AI instructions here]
```
- **Default persona**: `.github/chatmodes/oldbirba.chatmode.md`
- Chatmodes define **style, tone, and behavior** for content generation
- Always end AI responses with call-to-action

### Security & Configuration
- **No API keys in code** - use environment variables only
- **All secrets via GitHub secrets** or `.env` files (gitignored)
- Save **Markdown drafts before** any publishing API calls

## Folder Structure & Responsibilities

```
backend/          # FastAPI services (TOC API, Q&A endpoints)
frontend/         # Angular + Material (TOC tree, question input)
├── assets/       # Logo and static files (exploras branding)
├── src/app/      # Angular components (toc, question, answer)
samples/          # Working scripts (extract_epub_toc.py is the reference)
ebook/            # All epub files (any book with TOC works)
.github/
├── chatmodes/    # AI persona definitions (oldbirba.chatmode.md is default)
├── prompts/      # Workflow instructions (epub-knowledge-agent.istructions.md)
```

## Development Workflow (Experimental Prototype)

1. **Phase 1 (Current)**: Extend `samples/extract_epub_toc.py` to extract content by TOC selection
2. **Phase 2**: Build Angular UI with TOC tree selection + question input
3. **Phase 3**: Create FastAPI backend with endpoints:
   - `GET /toc` - Returns hierarchical TOC structure  
   - `POST /question` - Receives selected TOC + question, returns AI answer
4. **Phase 4**: Test cost optimization (measure tokens sent to OpenAI)

**Future**: Voice input for questions (not current scope)

## Testing Strategy
- **Unit tests**: pytest for backend, Jasmine/Karma for frontend
- **End-to-end**: Target the TOC → question → answer flow
- **Test epub**: Use provided Cloud-Native Ecosystems book as reference

## Key Integration Points
- **Frontend ↔ Backend**: REST API for TOC data and Q&A endpoints
- **Backend ↔ AI**: GPT-4o calls using chatmode system prompts
- **Backend ↔ EPUB**: ebooklib for parsing any uploaded epub files
- **Output formats**: Markdown (primary), HTML (optional), WordPress API (future)
