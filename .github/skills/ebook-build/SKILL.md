---
name: ebook-build
description: Build Kindle-compatible ebooks from markdown projects using PowerShell (EPUB, AZW3, MOBI). Use when converting documentation or book-style markdown into publishable ebook files with metadata, stylesheet, TOC, and optional EPUB page-list.
license: MIT
---

# Ebook Build Skill

## Overview

This skill packages the existing Kindle build flow as a reusable workflow.

It is designed for:
- Building ebooks from numbered markdown chapter structures
- Reusing the Kindle conversion toolchain already maintained in this repository
- Running the same flow on other repositories, such as github-copilot-skills-tutorial

## What This Skill Does

1. Detects source content root (direct or docs/)
2. Prepares an isolated build workspace
3. Reuses kindle conversion scripts and templates
4. Builds EPUB and optional AZW3/MOBI
5. Optionally injects EPUB page-list navigation
6. Copies resulting artifacts to the target output directory

## Requirements

- Windows PowerShell 5.1+
- Pandoc installed and available in PATH
- Calibre (ebook-convert) for AZW3/MOBI generation

## Inputs

Primary script: ./scripts/invoke-ebook-build.ps1

| Parameter | Required | Default | Description |
|---|---|---|---|
| sourceRoot | Yes | - | Source project root or docs root containing chapter folders |
| outputDir | No | sourceRoot/ebook-output | Destination for final ebook artifacts |
| projectName | No | folder name of sourceRoot | Base filename for outputs |
| formats | No | [epub, azw3, mobi] | Output formats to keep |
| enablePageList | No | true | Keep page-list injection step enabled |
| chapterDirPattern | No | ^\\d{2}- | Chapter directory pattern |
| chapterFilePattern | No | ^\\d{2}-.*\\.md$ | Chapter file pattern |
| coverFile | No | 00-COVER.md | Optional cover filename |
| preserveTemp | No | false | Keep temporary staging directory |
| metadataFile | No | ./.github/skills/ebook-build/configs/amazon-kdp-guide.metadata.yaml | Override metadata file |
| styleFile | No | ./.github/skills/ebook-build/assets/style.css | Override stylesheet file |
| configFile | No | - | Optional JSON config file |

## Config Files

- ./configs/amazon-kdp-guide.build.json
- ./configs/amazon-kdp-guide.metadata.yaml
- ./configs/github-copilot-skills-tutorial.build.json
- ./assets/style.css
- ./docs/README.md
- ./docs/KINDLE-COMPATIBILITY-CHECKLIST.md

## Quick Usage

### Build current amazon-kdp-guide repository

```powershell
./.github/skills/ebook-build/scripts/invoke-ebook-build.ps1 \
  -ConfigFile ./.github/skills/ebook-build/configs/amazon-kdp-guide.build.json
```

### Build github-copilot-skills-tutorial docs as an ebook

```powershell
./.github/skills/ebook-build/scripts/invoke-ebook-build.ps1 \
  -ConfigFile ./.github/skills/ebook-build/configs/github-copilot-skills-tutorial.build.json
```

## Output

The skill writes artifacts such as:
- project-name.epub
- project-name.azw3 (if ebook-convert available)
- project-name.mobi (if ebook-convert available)

## Notes

- This skill is intentionally non-interactive for agent execution.
- It patches staged conversion scripts to disable terminal prompts.
- For the operational guide, see ./docs/README.md.
- For detailed flow and constraints, see ./EBOOK_BUILD_SPECIFICATION.md.
- For validation criteria, see ./VALIDATION_CHECKLIST.md and ./docs/KINDLE-COMPATIBILITY-CHECKLIST.md.
