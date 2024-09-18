# get credentials
import tomllib
with open("credentials.toml", "rb") as f:
    c = tomllib.load(f)

ads_token = c["ads_token"]
libraries = ["all", "preprints"]

all_id = c["libraries"]["all"]["id"]
preprints_id = c["libraries"]["preprints"]["id"]

rule all:
    input:
        "build/Czekala_CV.pdf"

# all needs to be split, so it goes to a separate directory first
rule dl_json_all:
    input:
        "credentials.toml", src="src/get_library.py"
    output:
        "dl/all.json"
    shell:
        "python {input.src} {all_id} {ads_token} {output}"

# split `all` refereed files into `first` and `remaining`
rule split_json:
    input:
        "dl/all.json"
    output:
        "tmp/{name}.json"
    shell:
        "python src/split_json.py {input} {output}"

# preprints doesn't need to be split, it goes straight to tmp
rule dl_json_preprints:
    input:
        "credentials.toml", src="src/get_library.py"
    output:
        "tmp/preprints.json"
    shell:
        "python {input.src} {preprints_id} {ads_token} {output}"

# get list of static tex files
import glob 
statics = glob.glob("tex/static/*.tex")

# the bibliographies that will be in the latex document
bib_lists = ["first", "remaining", "preprints"]
templates = expand("tex/templates/{name}.tex", name=bib_lists)
filled = expand("tex/filled/{name}.tex", name=bib_lists)

rule fill_template:
    input: "src/format_pubs.py", tex="tex/templates/{name}.tex", json="tmp/{name}.json"
    output: "tex/filled/{name}.tex"
    shell:
        "python src/format_pubs.py {input.tex} {input.json} {output}"

# for debug,
# python src/format_pubs.py tex/templates/first.tex tmp/first.json tex/filled/first.tex

rule full_cv_tectonic:
    input: statics, templates, filled, tex="tex/full.tex"
    output: temp("tex/full.pdf")
    shell:
        "tectonic {input.tex}"

rule full_cv_pdf:
    input: "tex/full.pdf"
    output: "build/Czekala_CV.pdf"
    shell: "mv {input} {output}"
