.PHONY: all clean

SHELL := /bin/fish -l
DATESTAMP := $(shell date "+%Y%m%d")

# Find all TOML files in the data directory
DATA_FILES := $(wildcard data/*.toml)
# Generate output filenames without timestamps
OUTPUT_TARGETS := $(patsubst data/%.toml,output/%,$(DATA_FILES))

all: $(OUTPUT_TARGETS)

output:
	mkdir -p output

output/%: data/%.toml | output
	typst compile --input data_path=$< main.typ "$@_$(DATESTAMP).pdf"

clean:
	rm -rf output/
