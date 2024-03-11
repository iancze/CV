import requests
import json
import math
import xmltodict


def get_all_bibcodes(library_id, ads_token):
    """
    To get all of the documents, we need to paginate following the example at: https://github.com/adsabs/ads-examples/blob/master/library_csv/lib_2_csv.py

    Get the content of a library when you know its id. As we paginate the
    requests from the private library end point for document retrieval,
    we have to repeat requests until we have all documents.

    Parameters
    ----------
    library_id: str
        identifier of the library
    token: str
        ADS token for authentication


    Returns
    -------
    list
        list of bibcodes
    """

    # get the num_documents
    r = requests.get(
        "https://api.adsabs.harvard.edu/v1/biblib/libraries/{id}".format(id=library_id),
        headers={"Authorization": "Bearer " + ads_token},
    )

    num_documents = r.json()["metadata"]["num_documents"]

    start = 0
    rows = 25
    num_paginates = int(math.ceil(num_documents / (1.0 * rows)))

    documents = []
    for i in range(num_paginates):
        # print("Pagination {} out of {}".format(i + 1, num_paginates))
        r = requests.get(
            "https://api.adsabs.harvard.edu/v1/biblib/libraries/{id}?start={start}&rows={rows}".format(
                id=library_id, start=start, rows=rows
            ),
            headers={"Authorization": "Bearer " + ads_token},
        )

        # Get all the documents that are inside the library
        try:
            data = r.json()["documents"]
        except ValueError:
            raise ValueError(r.text)

        documents.extend(data)

        start += rows

    return documents


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Obtain the bibliographic information for all publications in an ADS library."
    )
    parser.add_argument(
        "library_id",
        help="The ID of the ADS library to retrieve. It's the alphanumeric string in the URL address.",
    )
    parser.add_argument("ads_token", help="Your ADS API token.")
    parser.add_argument("output", help="The location to write the JSON to.")
    args = parser.parse_args()

    bibcodes = get_all_bibcodes(args.library_id, args.ads_token)

    # get the publication data for all of these bibcodes in an easy-ish to work with XML format
    r = requests.post(
        "https://api.adsabs.harvard.edu/v1/export/refabsxml",
        headers={
            "Authorization": "Bearer " + args.ads_token,
            "Content-type": "application/json",
        },
        json={"bibcode": bibcodes},
    )

    # use xmltodict to convert to dict, then JSON
    export = r.json()["export"]
    data_dict = xmltodict.parse(export)
    records = data_dict["records"]["record"]

    with open(args.output, "w") as f:
        json.dump(records, f, ensure_ascii=False, indent=4)


if __name__ == "__main__":
    main()
