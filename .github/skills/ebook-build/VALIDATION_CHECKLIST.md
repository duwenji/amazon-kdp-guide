# Ebook Build Validation Checklist

## Build Execution

- [ ] Script exits with code 0
- [ ] No unexpected interactive prompts
- [ ] Output directory is created

## Artifacts

- [ ] EPUB output exists
- [ ] AZW3 output exists or clear warning is shown
- [ ] MOBI output exists or clear warning is shown
- [ ] Output filenames use projectName base

## Structural Quality

- [ ] TOC is generated
- [ ] Internal links work
- [ ] Heading hierarchy is readable
- [ ] Code blocks render correctly

## EPUB Optional Feature

- [ ] page-list step executed (enabled case)
- [ ] page-list insertion result is logged

## Compatibility

- [ ] Check with ./docs/KINDLE-COMPATIBILITY-CHECKLIST.md where applicable
- [ ] Preview EPUB in an EPUB reader
- [ ] Validate AZW3/MOBI on target Kindle environment
