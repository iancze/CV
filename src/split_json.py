import json
from pathlib import Path


def is_selected_pub(record: dict, nauthor=2) -> bool:
    """
    Parameters
    ----------
    record: dict
        an item in the publications list
    nauthor: int
        if IC is in this index (1-indexed) or earlier, this is a selected paper

    Returns
    -------
    bool
        Does the publication constitute a "selected" publication?
    """
    authors = record["author"]
    for i in range(nauthor):
        if "Czekala" in authors[i]:
            return True
    return False


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Filter the JSON pub list into another."
    )
    parser.add_argument("input", help="Path to input JSON.")
    parser.add_argument("output", help="Path to output JSON.")
    args = parser.parse_args()

    p = Path(args.output)

    # each JSON is a list of dictionaries
    with open(args.input, "r") as f:
        records = json.load(f)

    if p.name == "first.json":
        out = [record for record in records if is_selected_pub(record)]
        
    elif p.name == "remaining.json":
        out = [record for record in records if not is_selected_pub(record)
        ]
    else:
        print("output name not recognized.")
        return 

    with open(args.output, 'w', encoding='utf-8') as f:
        json.dump(out, f, ensure_ascii=False, indent=4)

if __name__=="__main__":
    main()