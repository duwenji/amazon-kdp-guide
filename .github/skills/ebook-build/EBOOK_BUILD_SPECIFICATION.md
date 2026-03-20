# Ebook Build Specification

## Goal

Provide a reusable, agent-friendly ebook build workflow based on the existing kindle conversion assets.

## Source Discovery

Given sourceRoot:

1. If sourceRoot contains chapter directories matching chapterDirPattern, use sourceRoot.
2. Otherwise, if sourceRoot/docs contains matching chapter directories, use sourceRoot/docs.
3. Otherwise, fail with a clear diagnostic.

## Chapter Contract

- Chapter directories: chapterDirPattern (default ^\\d{2}-)
- Section markdown files: chapterFilePattern (default ^\\d{2}-.*\\.md$)
- Cover file: coverFile (default 00-COVER.md, optional)

## Staging Contract

The runner creates an isolated temporary workspace:

- temp/book/                      (staged source root)
- temp/book/kindle/               (conversion scripts + staged metadata + staged css)
- temp/book/kindle/output/        (intermediate outputs)

## Build Steps

1. Validate required toolchain and files.
2. Stage source markdown content.
3. Stage conversion scripts and assets.
4. Patch staged script for non-interactive execution.
5. Run staged convert-to-kindle.ps1.
6. Copy selected format outputs to outputDir with projectName base.
7. Clean temp workspace unless preserveTemp is enabled.

## Format Behavior

- epub: expected if Pandoc is available
- azw3: expected when ebook-convert is available
- mobi: expected when ebook-convert is available

Missing optional formats produce warnings, not hard failures.

## Error Strategy

Hard fail:
- source root not found
- metadata/style not found
- required conversion script missing
- no chapter content found
- staged converter exits with non-zero status

Soft warnings:
- optional output format not produced
- page-list step logs warning but converter continues

## Reuse Scope

Reusable across repositories that satisfy chapter contract.

Known target examples:
- amazon-kdp-guide
- github-copilot-skills-tutorial/docs (partial sections may be skipped by naming rules)
