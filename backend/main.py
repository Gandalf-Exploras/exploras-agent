"""
FastAPI Backend for Exploras-Agent
Experimental prototype for cost-optimized Q&A on epub content
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Dict, Optional
import os
import sys

# Add samples directory to path to import epub functions
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'samples'))

try:
    from extract_epub_content import print_toc, get_content_by_href
    from ebooklib import epub
except ImportError:
    print("Warning: ebooklib not installed. Install with: pip install ebooklib beautifulsoup4")
    
app = FastAPI(
    title="Exploras-Agent API",
    description="Experimental API for cost-optimized Q&A on epub content",
    version="0.1.0"
)

# Enable CORS for frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:4200"],  # Angular dev server
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Data models
class TOCItem(BaseModel):
    id: str
    title: str
    href: str
    level: int

class QuestionRequest(BaseModel):
    toc_id: str
    question: str
    
class AnswerResponse(BaseModel):
    answer: str
    context_length: int
    toc_title: str

# Global variables (in production, use proper state management)
current_book = None
current_toc_items = []
epub_path = os.path.join('ebook', 'Cloud-Native Ecosystems - Mauro Giuliano.epub')

def load_epub():
    """Load epub file and extract TOC structure"""
    global current_book, current_toc_items
    try:
        current_book = epub.read_epub(epub_path)
        # Get TOC items using our existing function
        sys.stdout = open(os.devnull, 'w')  # Suppress print output
        current_toc_items = print_toc(current_book.toc)
        sys.stdout = sys.__stdout__  # Restore stdout
        return True
    except Exception as e:
        print(f"Error loading epub: {e}")
        return False

@app.on_event("startup")
async def startup_event():
    """Load epub on startup"""
    if not load_epub():
        print("Warning: Could not load epub file")

@app.get("/")
async def root():
    return {"message": "Exploras-Agent API is running", "epub_loaded": current_book is not None}

@app.get("/toc", response_model=List[TOCItem])
async def get_toc():
    """Get hierarchical TOC structure"""
    if not current_book:
        raise HTTPException(status_code=503, detail="EPUB not loaded")
    
    toc_response = []
    for item in current_toc_items:
        toc_response.append(TOCItem(
            id=item['id'],
            title=item['title'],
            href=item['href'],
            level=item['level']
        ))
    
    return toc_response

@app.post("/question", response_model=AnswerResponse)
async def ask_question(request: QuestionRequest):
    """Process question with selected TOC context"""
    if not current_book:
        raise HTTPException(status_code=503, detail="EPUB not loaded")
    
    # Find selected TOC item
    selected_item = None
    for item in current_toc_items:
        if item['id'] == request.toc_id:
            selected_item = item
            break
    
    if not selected_item:
        raise HTTPException(status_code=404, detail="TOC ID not found")
    
    # Extract content for selected TOC section
    content = get_content_by_href(current_book, selected_item['href'])
    
    if not content:
        raise HTTPException(status_code=404, detail="Content not found for selected TOC section")
    
    # TODO: Call OpenAI API with content + question
    # For now, return mock response
    mock_answer = f"""This is a mock answer for your question: "{request.question}"

Based on the selected section "{selected_item['title']}", here would be the AI-generated response using only the relevant content from that chapter/section.

In a real implementation, this would:
1. Send the extracted content ({len(content)} characters) to OpenAI
2. Include your question as the user prompt
3. Return the AI-generated contextual answer

This approach reduces costs by sending only relevant sections instead of the entire book."""

    return AnswerResponse(
        answer=mock_answer,
        context_length=len(content),
        toc_title=selected_item['title']
    )

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "epub_loaded": current_book is not None,
        "toc_items_count": len(current_toc_items)
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
