PAGE ?= ../index.html
SOURCE_LANG ?= ca
TARGET_LANG ?= en

.PHONY: translate check help

help:
	@printf '%s\n' 'Targets:'
	@printf '%s\n' '  make translate  Translate the source language block into the target language block.'
	@printf '%s\n' '  make check      Check that the bilingual blocks exist in the page.'

translate:
	python3 translate_informative_pages.py --page "$(PAGE)" --source-lang "$(SOURCE_LANG)" --target-lang "$(TARGET_LANG)"

check:
	python3 translate_informative_pages.py --page "$(PAGE)" --source-lang "$(SOURCE_LANG)" --target-lang "$(TARGET_LANG)" --check
