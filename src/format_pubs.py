from jinja2 import Environment, FileSystemLoader, select_autoescape
from pathlib import Path
import json 
import utf8totex

def format_authors(author_list:list, num:int=4) -> str:
    """
    Parameters
    ----------
    authors_list: list
        list of strings of authors 
    num: int
        number of authors

    Returns
    -------
    str:
        formatted string
    """

    truncated_raw = author_list[:num]
    IC_shown = False

    # convert all shown authors to appropriate tex
    truncated_list = [utf8totex.utf8totex(author) for author in truncated_raw] 

    # search through first num entries
    # if 'Czekala' in them, replace with formatted version
    for idx, entry in enumerate(truncated_list):
        if 'Czekala' in entry:
            truncated_list[idx] = "\\textbf{Czekala, Ian}"
            IC_shown = True # my name appears spelled out
            break

    authors = "; ".join(truncated_list)
    
    if len(author_list) > num:
        authors += "; \\emph{et al.}"

    if not IC_shown:
        authors += " (incl \\textbf{IC})"

    return authors

def get_citation_str(record:dict) -> str:
    """
    Parameters
    ----------
    record: dict
        an item in the publications list

    Returns
    -------
    str:
        the number of citations linked the the page
    """
    link_list  = record["link"]

    # citations are provided by a dict entry with @type = "citations"
    for item in link_list:
        if item["@type"] == "citations":
            count = item["count"]
            url = item["url"]

            citation_str = (
                "\\href{{{:}}}".format(url) + "{Citations: " + "{:}".format(count) + "}"
            )

            return citation_str
    
    return ""

def format_publication(record:dict)->str:
    """
    Parameters
    ----------
    record: dict
        an item in the publications list

    Returns
    -------
    str
        The publication rendered as formatted string ready for LaTeX consumption.
    """
    title = record["title"]
    journal = record["journal"]
    url = record["url"]

    authors = format_authors(record["author"])

    # get citations count from link
    citation_str = get_citation_str(record)
    
    # format article title in steps 
    # convert utf8 to appropriate tex characters
    title_0 = utf8totex.utf8totex(title)
    title_1 = "\\emph{{{:}}}".format(title_0) # italicize
    title_2 = "\\href{{{:}}}{{{:}}}".format(url, title_1) # link url

    # \\ to escape \
    # {{}} to escape {}
    return "{:}, {:}, {:}, {:}".format(authors, title_2, journal, citation_str)

def get_publications_list(json_file):
    with open(json_file, "r") as f:
        records = json.load(f)

    return [format_publication(record) for record in records]

    
def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Format the Jinja2 template with publication information."
    )
    parser.add_argument("template", help="Path to Jinja template.")
    parser.add_argument("pub_json", help="Path to publication JSON list.")
    parser.add_argument("output", help="Path to write formatted tex.")
    args = parser.parse_args()

    # use pathlib to play with the way Jinja wants loaders and files
    p = Path(args.template)

    loader = FileSystemLoader(p.parent)
    env = Environment(loader=loader, autoescape=select_autoescape(), trim_blocks=True, lstrip_blocks=True)
    template = env.get_template(p.name)

    # format publications as list items from json
    publications = get_publications_list(args.pub_json)

    # pass a list of formatted publications
    output = template.render(publications=publications)

    with open(args.output, "w") as f:
        f.write(output)

if __name__=="__main__":
    main()