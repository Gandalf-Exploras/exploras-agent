import sys
import os
from ebooklib import epub
import ebooklib
from bs4 import BeautifulSoup

# Path to epub file (modify as needed)
epub_path = 'ebook/Cloud-Native Ecosystems - Mauro Giuliano.epub'

def print_toc(toc, level=0):
    """Print TOC structure with IDs for selection"""
    toc_items = []
    for i, item in enumerate(toc):
        if isinstance(item, epub.Link):
            item_id = f"toc_{level}_{i}"
            title = item.title
            href = item.href
            print('  ' * level + f'[{item_id}] - {title}')
            toc_items.append({
                'id': item_id,
                'title': title,
                'href': href,
                'level': level,
                'link': item
            })
        elif isinstance(item, tuple) and len(item) == 2:
            section, children = item
            section_id = f"toc_{level}_{i}"
            print('  ' * level + f'[{section_id}] [{section.title}]')
            toc_items.append({
                'id': section_id,
                'title': section.title,
                'href': getattr(section, 'href', ''),
                'level': level,
                'link': section
            })
            # Recursively get children (limit to level 2)
            if level < 2:
                child_items = print_toc(children, level + 1)
                toc_items.extend(child_items)
        else:
            print('  ' * level + str(item))
    return toc_items

def get_content_by_href(book, href):
    """Extract text content from a specific href/chapter"""
    try:
        # Remove fragment identifier if present
        clean_href = href.split('#')[0]
        
        # Find the item in the book
        for item in book.get_items():
            if item.get_name() == clean_href:
                if item.get_type() == ebooklib.ITEM_DOCUMENT:
                    # Parse HTML content and extract text
                    soup = BeautifulSoup(item.get_content(), 'html.parser')
                    # Remove script and style elements
                    for script in soup(["script", "style"]):
                        script.decompose()
                    text = soup.get_text()
                    # Clean up whitespace
                    lines = (line.strip() for line in text.splitlines())
                    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
                    text = '\n'.join(chunk for chunk in chunks if chunk)
                    return text
        return None
    except Exception as e:
        print(f"Error extracting content from {href}: {e}")
        return None

def interactive_content_extraction():
    """Interactive mode to select TOC items and extract content"""
    try:
        book = epub.read_epub(epub_path)
        toc = book.toc
        
        print('=== EPUB TOC Structure ===')
        toc_items = print_toc(toc)
        
        print('\n=== Interactive Content Extraction ===')
        print('Enter TOC ID to extract content (or "quit" to exit):')
        
        while True:
            user_input = input('\nTOC ID > ').strip()
            
            if user_input.lower() == 'quit':
                break
                
            # Find the selected TOC item
            selected_item = None
            for item in toc_items:
                if item['id'] == user_input:
                    selected_item = item
                    break
            
            if selected_item:
                print(f"\n--- Content for: {selected_item['title']} ---")
                content = get_content_by_href(book, selected_item['href'])
                if content:
                    # Truncate for display (first 500 chars)
                    if len(content) > 500:
                        print(content[:500] + "\n... (truncated)")
                        print(f"\nFull content length: {len(content)} characters")
                    else:
                        print(content)
                else:
                    print("No content found for this TOC item.")
            else:
                print(f"TOC ID '{user_input}' not found. Please try again.")
                
    except Exception as e:
        print(f'Error during interactive extraction: {e}')

def main():
    """Main function - can run in different modes"""
    if len(sys.argv) > 1 and sys.argv[1] == 'interactive':
        interactive_content_extraction()
    else:
        # Default: just print TOC
        try:
            book = epub.read_epub(epub_path)
            toc = book.toc
            print('=== EPUB TOC Structure ===')
            print_toc(toc)
            print('\nRun with "interactive" argument to extract content by TOC selection.')
        except Exception as e:
            print(f'Error reading epub file: {e}')

if __name__ == '__main__':
    main()
