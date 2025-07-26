import sys
from ebooklib import epub

# Percorso del file epub (modifica se necessario)
epub_path = 'ebook/Cloud-Native Ecosystems - Mauro Giuliano.epub'

def print_toc(toc, level=0):
    for item in toc:
        if isinstance(item, epub.Link):
            print('  ' * level + f'- {item.title}')
        elif isinstance(item, tuple) and len(item) == 2:
            section, children = item
            print('  ' * level + f'[{section.title}]')
            print_toc(children, level + 1)
        else:
            print('  ' * level + str(item))

def main():
    try:
        book = epub.read_epub(epub_path)
        toc = book.toc
        print('Sommario del libro:')
        print_toc(toc)
    except Exception as e:
        print(f'Errore durante la lettura del file epub: {e}')

if __name__ == '__main__':
    main()
