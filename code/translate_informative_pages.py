#!/usr/bin/env python3
"""Translate language blocks in the static informative HTML page.

The script treats the source language block as the newest version and replaces
the target language block with a translated fragment while preserving the page
structure around both blocks.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path


def block_pattern(lang: str) -> re.Pattern[str]:
    return re.compile(
        rf'(?P<open><div data-lang="{re.escape(lang)}"(?: hidden)?>)'
        rf'(?P<body>.*?)'
        rf'(?P<close>\n\s*</div>)',
        re.DOTALL,
    )


def extract_block(html: str, lang: str) -> re.Match[str]:
    matches = list(block_pattern(lang).finditer(html))
    if not matches:
        raise ValueError(f'No block found for data-lang="{lang}".')
    return max(matches, key=lambda match: len(match.group("body")))


def translate_fragment(fragment: str, source_lang: str, target_lang: str) -> str:
    api_key = os.environ.get("OPENAI_API_KEY")
    model = os.environ.get("OPENAI_MODEL")
    if not api_key or not model:
        raise RuntimeError("Set OPENAI_API_KEY and OPENAI_MODEL before running translations.")

    payload = {
        "model": model,
        "input": [
            {
                "role": "system",
                "content": (
                    "Translate only human-readable prose in the HTML fragment. "
                    "Preserve tags, attributes, indentation, code blocks, URLs, "
                    "email addresses, command examples, file names, and proper nouns. "
                    "Return only the translated HTML fragment."
                ),
            },
            {
                "role": "user",
                "content": f"Translate from {source_lang} to {target_lang}:\n\n{fragment}",
            },
        ],
    }
    request = urllib.request.Request(
        "https://api.openai.com/v1/responses",
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(request, timeout=120) as response:
            data = json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"Translation API request failed: {detail}") from exc

    if data.get("output_text"):
        return data["output_text"].strip()

    for item in data.get("output", []):
        for content in item.get("content", []):
            if content.get("type") == "output_text" and content.get("text"):
                return content["text"].strip()

    raise RuntimeError("Translation API response did not include translated text.")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--page", default="../index.html", help="HTML page to update.")
    parser.add_argument("--source-lang", default="ca", help="Source data-lang value.")
    parser.add_argument("--target-lang", default="en", help="Target data-lang value.")
    parser.add_argument("--check", action="store_true", help="Only validate that both language blocks exist.")
    parser.add_argument("--dry-run", action="store_true", help="Print the translated fragment without writing the page.")
    args = parser.parse_args()

    page = Path(args.page)
    html = page.read_text(encoding="utf-8")
    source = extract_block(html, args.source_lang)
    target = extract_block(html, args.target_lang)

    if args.check:
        print(f"OK: found {args.source_lang} and {args.target_lang} blocks in {page}")
        return 0

    translated = translate_fragment(source.group("body").strip(), args.source_lang, args.target_lang)
    if args.dry_run:
        print(translated)
        return 0

    replacement = f'{target.group("open")}\n{translated}{target.group("close")}'
    updated = html[: target.start()] + replacement + html[target.end() :]
    page.write_text(updated, encoding="utf-8")
    print(f"Updated {args.target_lang} block in {page} from {args.source_lang}.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"error: {exc}", file=sys.stderr)
        raise SystemExit(1)
