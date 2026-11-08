# CORRECTIONS.en.md

## Target repository
- **Name:** dk-smart
- **URL:** https://github.com/hl7dk/dk-smart
- **Default branch (upstream):** master
- **Base commit analyzed:** 29e5bd0
- **Date of preparation:** 2026-11-08 (local time)
- **Author:** admeduardovieira (Kilo, REA 6.7.0)

---

## Corrections implemented

No code corrections were implemented, as the repository is a FHIR IG/SUSHI project with configuration files and FSH definitions, not executable source code. The improvements identified are build infrastructure and documentation.

## Improvements identified (not implemented)

### REA-DKSMART-001 — publisher.jar not versioned
**Problem:** Build depends on publisher.jar not in Git (in .gitignore).
**Proposed correction:** Document the publisher.jar download process in README or version the file.
**Files:** README.md, _genonce.sh/.bat, _updatePublisher.sh/.bat, .github/workflows/build.yml

### REA-DKSMART-002 — No automated tests
**Problem:** No validation tests for FSH files or generated IG.
**Proposed correction:** Add validation tests for FSH files and generated IG.
**Files:** new test files

### REA-DKSMART-003 — Hardcoded external server URL
**Problem:** instances.fsh references gravitate-ips.gravitate.tcs.trifork.dev as example server.
**Proposed correction:** Replace with configuration variable or local/example hosted by project.
**Files:** input/fsh/instances.fsh

### REA-DKSMART-004 — Hardcoded date in CapabilityStatement
**Problem:** dk-smart-server.fsh:7 uses fixed date "2023-11-09".
**Proposed correction:** Update to current date or use automatic substitution marker.
**Files:** input/fsh/dk-smart-server.fsh

### REA-DKSMART-005 — Inconsistency version/status/releaseLabel
**Problem:** version 1.1.0 with status draft and releaseLabel ci-build.
**Proposed correction:** Align status and releaseLabel with version (e.g. status active, releaseLabel release for publication).
**Files:** sushi-config.yaml

---

*This document records build infrastructure improvements identified, without source code changes.*
