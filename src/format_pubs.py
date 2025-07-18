from jinja2 import Environment, FileSystemLoader, select_autoescape
from pathlib import Path
import json 
import utf8totex
import re

# correct mapping of bibcode to tex-friendly title
title_map = {
    "2021ApJS..257....6G": "Molecules with ALMA at Planet-forming Scales (MAPS). VI. Distribution of the Small Organics HCN, $\mathrm{C}_2\mathrm{H}$, and $\mathrm{H}_2\mathrm{CO}$",
    "2021ApJS..257...13A": "Molecules with ALMA at Planet-forming Scales (MAPS). XIII. $\mathrm{HCO}^+$ and Disk Ionization Structure",
    "2021ApJS..257....9I": "Molecules with ALMA at Planet-forming Scales (MAPS). IX. Distribution and Properties of the Large Organic Molecules $\mathrm{HC}_3\mathrm{N}$, $\mathrm{CH}_3\mathrm{CN}$, and c-$\mathrm{C}_3\mathrm{H}_2$",
    "2025ApJ...984L..18T": "exoALMA. XIII. Gas Masses from $\mathrm{N}_2\mathrm{H}^+$ and $\mathrm{C}^{18}\mathrm{O}$: A Comparison of Measurement Techniques for Protoplanetary Gas Disk Masses",
    "2025ApJ...984L..15P": "exoALMA. X. Channel Maps Reveal Complex ${}^{12}\mathrm{CO}$ Abundance Distributions and a Variety of Kinematic Structures with Evidence for Embedded Planets"
}


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

def trim_journal_entry(s:str)->str:
    """
    Parameters
    ----------
    s: str
        the journal entry string

    Returns
    -------
    str
        The journal entry string stripped of a year, if it was present.
    
    """
    # as far as we can tell, the year is always in parentheses and at the end of the string.
    # annoyingly, sometimes the journal key contains the year, other times it doesn't. So, compare
    # "The Astrophysical Journal, Volume 883, Issue 1, article id. 22, 24 pp. (2019).",
    # to
    # "Publications of the Astronomical Society of the Pacific, Volume 135, Issue 1048, id.064503, 24 pp.",

    p = re.compile(r'\([12]\d\d\d\)') # match (1999) or (2010), etc.

    # see if this occurs in our string
    m = p.search(s)
    if m:
        # trim from the position of the find
        s = s[:m.start()]
        # then trim any whitespace
        s = s.rstrip()

        # do it this way in case we had something like '.(2020)'
        # as opposed to s = s[:m.start() - 1]

    return s

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
    url = record["url"]
    pubdate = record["pubdate"]
    journal = trim_journal_entry(record["journal"])

    authors = format_authors(record["author"])

    # get citations count from link
    citation_str = get_citation_str(record)
    
    # format article title in steps 
    # convert utf8 to appropriate tex characters
    title_0 = utf8totex.utf8totex(title)

    # replace title if known trouble 
    bibcode = record["bibcode"]
    if bibcode in title_map.keys():
        title_0 = title_map[bibcode]

    # \\ to escape \
    # {{}} to escape {}
    title_1 = "\\emph{{{:}}}".format(title_0) # italicize
    title_2 = "\\href{{{:}}}{{{:}}}".format(url, title_1) # link url

    return f"{authors} {pubdate}, {title_2}, {journal}, {citation_str}"
    
def get_publications_list(json_file, name):
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
    publications = get_publications_list(args.pub_json, p.name)

    # pass a list of formatted publications
    output = template.render(publications=publications)

    with open(args.output, "w") as f:
        f.write(output)

if __name__=="__main__":
    main()