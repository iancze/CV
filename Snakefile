# get credentials
import tomllib
with open("credentials.toml", "rb") as f:
    c = tomllib.load(f)

ads_token = c["ads_token"]
library_order = ["first", "everything", "preprints"]

rule all:
    input:
        "build/Czekala_CV.pdf"

def get_library_id(wildcards):
    return c["libraries"][wildcards.name]["id"]

rule dl_json_library:
    input:
        src="src/get_library.py",
    params:
        id=get_library_id
    output:
        "tmp/{name}.json"
    shell:
        "python {input.src} {params.id} {ads_token} {output}"

libraries = expand("tmp/{name}.json", name=library_order)

# get list of static tex files
import glob 
statics = glob.glob("tex/static/*.tex")

templates = expand("tex/templates/{name}.tex", name=library_order)
filled = expand("tex/filled/{name}.tex", name=library_order)

rule fill_template:
    input: "src/format_pubs.py", tex="tex/templates/{name}.tex", json="tmp/{name}.json"
    output: "tex/filled/{name}.tex"
    shell:
        "python src/format_pubs.py {input.tex} {input.json} {output}"

rule full_cv_tectonic:
    input: statics, templates, filled, tex="tex/full.tex"
    output: temp("tex/full.pdf")
    shell:
        "tectonic {input.tex}"

rule full_cv_pdf:
    input: "tex/full.pdf"
    output: "build/Czekala_CV.pdf"
    shell: "mv {input} {output}"
