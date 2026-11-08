# REVERSE_ENGINEERING_REPORT.en.md

## Target repository
- **Name:** dk-smart
- **URL:** https://github.com/hl7dk/dk-smart
- **Default branch (upstream):** master
- **Base commit analyzed:** 29e5bd0 (Update publication-request.json)
- **Project version:** 1.1.0 (sushi-config.yaml), status draft
- **Local working folder:** C:\Users\User\audit-repos\dk-smart
- **Audit folder:** C:\Users\User\audit-repos\audit-work
- **Audit date/time:** 2026-11-08 (local time)
- **Environment:** Windows, PowerShell 5.1, Git 2.49.0, Python 3.12.14 (without SUSHI/IG Publisher installed)

---

## A. General diagnosis

### Architecture identified
FHIR R4 Implementation Guide (IG) for Danish SMART App Launch, built with SUSHI (FHIR Shorthand). The IG provides guidelines for using the SMART App Launch mechanism in Denmark.

Structure:
- `sushi-config.yaml` — IG configuration (id, canonical, name, version 1.1.0, dependencies, pages, menu, releaseLabel: ci-build)
- `ig.ini` — points to generated ImplementationGuide in fsh-generated/resources/, template https://github.com/hl7dk/dk-ig-template
- `input/fsh/` — 3 FSH files: dk-smart-server-profile.fsh (CapabilityStatement Profile), dk-smart-server.fsh (CapabilityStatement Instance), instances.fsh (example-ipa-server Instance)
- `input/pagecontent/` — 4 Markdown pages: index.md, conformance.md, examples.md, downloads.md
- `input/includes/` — fragment-footer.html
- `input/ignoreWarnings.txt` — validator warning suppression
- Build scripts: _genonce.sh/.bat, _gencontinuous.sh/.bat, _updatePublisher.sh/.bat
- `.github/workflows/build.yml` — CI/CD via GitHub Actions (Docker hl7fhir/ig-publisher-base, download publisher.jar, build IG, deploy GitHub Pages)
- `.gitignore` — ignores /fsh-generated, /input-cache, /output, /temp, /template, /temp-publish, /web-root
- `LICENSE` — CC0 1.0 Universal
- `publication-request.json` — metadata for build.fhir.org publication

### Technologies and dependencies
- SUSHI (FHIR Shorthand)
- FHIR R4 (fhirVersion: 4.0.1)
- Dependencies: hl7.fhir.uv.ipa 1.0.0, hl7.fhir.uv.smart-app-launch 2.2.0
- IG Publisher (publisher.jar, downloaded via CI, not versioned in Git)
- Java (to run publisher.jar)
- Node.js (GitHub Actions workflow)
- License: CC0-1.0

### Maintenance status
- Active: version 1.1.0 draft, multiple recent commits
- Last commit: 29e5bd0 (Update publication-request.json)
- Public build: https://build.fhir.org/ig/hl7dk/dk-smart
- CI/CD configured: GitHub Actions (build.yml) with deploy to GitHub Pages
- No automated tests visible

### Existing test mechanisms
- No automated code tests
- Validation via IG Publisher (external, in CI)
- ignoreWarnings.txt for suppression of known warnings

### Investigation limitations
- SUSHI and IG Publisher not installed → impossible to execute IG build locally
- Analysis based on static inspection of YAML configuration, FSH files, build scripts and CI/CD workflow

---

## B. Problems found

| ID | Location | Problem | Status | Severity | Evidence |
|----|----------|---------|--------|----------|-----------|
| REA-DKSMART-001 | `_genonce.sh/.bat`, `_updatePublisher.sh/.bat`, `.github/workflows/build.yml:36` | `publisher.jar` not versioned in Git → build depends on manual download or CI to obtain publisher.jar | CONFIRMED (static) | P2 | .gitignore ignores /input-cache; _updatePublisher scripts and build.yml download publisher.jar from https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar |
| REA-DKSMART-002 | Absent | No automated tests for FSH files or IG validation | CONFIRMED (static) | P3 | No test files found in repository |
| REA-DKSMART-003 | `instances.fsh:16` | Hardcoded URL to external example server (gravitate-ips.gravitate.tcs.trifork.dev) → dependency on external service that may become unavailable | HYPOTHESIS | P3 | Line 16: `url = "https://gravitate-ips.gravitate.tcs.trifork.dev/fhir/metadata"` and lines 29,32 with OAuth URIs from same domain |
| REA-DKSMART-004 | `dk-smart-server.fsh:7` | Hardcoded date "2023-11-09" in CapabilityStatement instance → may become outdated without review | HYPOTHESIS | P3 | Line 7: `date = "2023-11-09"` |
| REA-DKSMART-005 | `sushi-config.yaml:52-57` | version 1.1.0 with status: draft and releaseLabel: ci-build → inconsistency between stable version and development state | HYPOTHESIS | P3 | Line 52: `version: 1.1.0`, line 55: `status: draft`, line 57: `releaseLabel: ci-build` |

### No P0 or P1 problems
No critical problem confirmed.

---

## C. Recurring problems
GitHub issues:
- #1: "Clarify text on MinLog" (CLOSED)
- #2: "Consider restriction on the use of symmetric keys" (CLOSED)
- #3: "Best practices from FAPI" (OPEN)
- #4: "Describe link to DK Core and IPA" (CLOSED)

No open or closed PRs. No documented regressions identified. Issue #3 (FAPI best practices) remains open and may be related to authorization security.

---

## D. Undocumented errors
REA-DKSMART-001 to REA-DKSMART-005 were not documented in issues/PRs.

---

## E. Performance
No relevant performance opportunities in a FHIR IG (build executed externally via IG Publisher/CI).

---

## F. Technical improvements
1. Version publisher.jar or document download process clearly (REA-DKSMART-001)
2. Add automated FSH/IG validation tests (REA-DKSMART-002)
3. Replace hardcoded external server URL with configuration variable or local example (REA-DKSMART-003)
4. Update CapabilityStatement date or make it automatic (REA-DKSMART-004)
5. Align version 1.1.0 with appropriate status (draft vs active) and releaseLabel (REA-DKSMART-005)
6. Add CODEOWNERS or CONTRIBUTING.md to guide contributions

---

## G. Execution plan
All improvements are independent and low risk, but there is no complex source code to fix. These are build infrastructure and documentation improvements.

---

## H. Expected result
More reproducible build, validation tests, removal of external server dependency, clear onboarding documentation.

---

## Malware and threat analysis (static)
**Result:** No indicator identified by the static analysis performed.
- Only configuration files (YAML, INI, FSH, MD, JSON), build scripts (BAT, SH), CI/CD workflow and images
- Build scripts and workflow download publisher.jar from https://github.com/HL7/fhir-ig-publisher/releases/ (official HL7 source) — legitimate network call
- instances.fsh references example server URLs (gravitate-ips.gravitate.tcs.trifork.dev) and smarthealthit.org — public FHIR sources, not credentials
- No credentials, keys, tokens or passwords embedded
- No suspicious shell commands, subprocess, exec, eval, persistence, obfuscation or data exfiltration
- It is not stated that the project is free of malware.

---

## Mandatory final questions
1. **Which critical bugs were confirmed?** None P0/P1.
2. **Which recurring problems have developers not yet resolved?** Not enough history of regressions. Issue #3 (FAPI best practices) remains open.
3. **Which important errors were not documented?** publisher.jar not versioned, no automated tests, hardcoded external server URL, hardcoded CapabilityStatement date, inconsistency version/status/releaseLabel.
4. **Which performance opportunities were found?** None relevant.
5. **Which security and reliability improvements are justifiable?** Version publisher.jar, add CI/CD tests, remove hardcoded external server dependency, document onboarding.
6. **Which fixes can be made quickly?** Document publisher.jar, update CapabilityStatement date, align version/status/releaseLabel.
7. **Which are the three contributions with highest technical value?** (a) FSH/IG validation tests, (b) CI/CD already exists, improve onboarding documentation (publisher.jar), (c) remove external server dependency.
8. **Which fixes should be avoided for lack of evidence?** None — all are well-founded build infrastructure improvements.
9. **Which modifications do you recommend implementing first?** Onboarding documentation (publisher.jar) and FSH validation tests.
