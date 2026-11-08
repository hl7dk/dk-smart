# CORRECTIONS.md

## Repositório alvo
- **Nome:** dk-smart
- **URL:** https://github.com/hl7dk/dk-smart
- **Branch padrão (upstream):** master
- **Commit-base analisado:** 29e5bd0
- **Data da elaboração:** 2026-11-08 (horário local)
- **Autor:** admeduardovieira (Kilo, REA 6.7.0)

---

## Correções implementadas

Nenhuma correção de código foi implementada, pois o repositório é um IG FHIR/SUSHI com arquivos de configuração e definições FSH, não código-fonte executável. As melhorias identificadas são de infraestrutura de build e documentação.

## Melhorias identificadas (não implementadas)

### REA-DKSMART-001 — publisher.jar não versionado
**Problema:** O build depende de publisher.jar que não está no Git (está no .gitignore).
**Correção proposta:** Documentar o processo de download do publisher.jar no README ou versionar o arquivo.
**Arquivos:** README.md, _genonce.sh/.bat, _updatePublisher.sh/.bat, .github/workflows/build.yml

### REA-DKSMART-002 — Sem testes automatizados
**Problema:** Nenhum teste de validação dos arquivos FSH ou do IG gerado.
**Correção proposta:** Adicionar testes de validação dos arquivos FSH (ex. sushi válido) e do IG gerado.
**Arquivos:** novos arquivos de teste

### REA-DKSMART-003 — URL hardcoded de servidor externo
**Problema:** instances.fsh referencia gravitate-ips.gravitate.tcs.trifork.dev como servidor de exemplo.
**Correção proposta:** Substituir por variável de configuração ou exemplo local/hospedado pelo projeto.
**Arquivos:** input/fsh/instances.fsh

### REA-DKSMART-004 — Data hardcoded no CapabilityStatement
**Problema:** dk-smart-server.fsh:7 usa data fixa "2023-11-09".
**Correção proposta:** Atualizar para data corrente ou usar marcador de substituição automática.
**Arquivos:** input/fsh/dk-smart-server.fsh

### REA-DKSMART-005 — Inconsistência versão/status/releaseLabel
**Problema:** version 1.1.0 com status draft e releaseLabel ci-build.
**Correção proposta:** Alinhar status e releaseLabel com a versão (ex: status active, releaseLabel release para publicação).
**Arquivos:** sushi-config.yaml

---

*Este documento registra melhorias de infraestrutura identificadas, sem alterações de código-fonte.*
