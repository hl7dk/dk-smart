# REVERSE_ENGINEERING_REPORT.md

## Repositório alvo
- **Nome:** dk-smart
- **URL:** https://github.com/hl7dk/dk-smart
- **Branch padrão (upstream):** master
- **Commit-base analisado:** 29e5bd0 (Update publication-request.json)
- **Versão do projeto:** 1.1.0 (sushi-config.yaml), status draft
- **Pasta de trabalho local:** C:\Users\User\audit-repos\dk-smart
- **Pasta de auditoria:** C:\Users\User\audit-repos\audit-work
- **Data/horário da auditoria:** 2026-11-08 (horário local)
- **Ambiente:** Windows, PowerShell 5.1, Git 2.49.0, Python 3.12.14 (sem SUSHI/IG Publisher instalados)

---

## A. Diagnóstico geral

### Arquitetura identificada
Implementation Guide (IG) FHIR R4 para Danish SMART App Launch, construído com SUSHI (FHIR Shorthand). O IG fornece diretrizes para uso do mecanismo SMART App Launch na Dinamarca.

Estrutura:
- `sushi-config.yaml` — configuração do IG (id, canonical, name, version 1.1.0, dependências, páginas, menu, releaseLabel: ci-build)
- `ig.ini` — aponta para o ImplementationGuide gerado em fsh-generated/resources/, template https://github.com/hl7dk/dk-ig-template
- `input/fsh/` — 3 arquivos FSH: dk-smart-server-profile.fsh (Profile CapabilityStatement), dk-smart-server.fsh (Instance CapabilityStatement), instances.fsh (Instance example-ipa-server)
- `input/pagecontent/` — 4 páginas Markdown: index.md, conformance.md, examples.md, downloads.md
- `input/includes/` — fragment-footer.html
- `input/ignoreWarnings.txt` — supressão de avisos do validador
- Scripts de build: _genonce.sh/.bat, _gencontinuous.sh/.bat, _updatePublisher.sh/.bat
- `.github/workflows/build.yml` — CI/CD via GitHub Actions (Docker hl7fhir/ig-publisher-base, download publisher.jar, build IG, deploy GitHub Pages)
- `.gitignore` — ignora /fsh-generated, /input-cache, /output, /temp, /template, /temp-publish, /web-root
- `LICENSE` — CC0 1.0 Universal
- `publication-request.json` — metadados para publicação no build.fhir.org

### Tecnologias e dependências
- SUSHI (FHIR Shorthand)
- FHIR R4 (fhirVersion: 4.0.1)
- Dependências: hl7.fhir.uv.ipa 1.0.0, hl7.fhir.uv.smart-app-launch 2.2.0
- IG Publisher (publisher.jar, baixado via CI, não versionado no Git)
- Java (para rodar publisher.jar)
- Node.js (workflow GitHub Actions)
- Licença: CC0-1.0

### Estado de manutenção
- Ativo: versão 1.1.0 draft, múltiplos commits recentes
- Último commit: 29e5bd0 (Update publication-request.json)
- Build público: https://build.fhir.org/ig/hl7dk/dk-smart
- CI/CD configurado: GitHub Actions (build.yml) com deploy para GitHub Pages
- Nenhum teste automatizado visível

### Mecanismos de testes existentes
- Nenhum teste automatizado de código
- Validação via IG Publisher (externo, no CI)
- ignoreWarnings.txt para supressão de avisos conhecidos

### Limitações da investigação
- SUSHI e IG Publisher não instalados → impossível executar o build do IG localmente
- Análise baseada em inspeção estática de configuração YAML, arquivos FSH, scripts de build e workflow CI/CD

---

## B. Problemas encontrados

| ID | Localização | Problema | Status | Severidade | Evidência |
|----|-------------|----------|--------|------------|-----------|
| REA-DKSMART-001 | `_genonce.sh/.bat`, `_updatePublisher.sh/.bat`, `.github/workflows/build.yml:36` | `publisher.jar` não versionado no Git → build depende de download manual ou CI para obter publisher.jar | CONFIRMADO (estática) | P2 | .gitignore ignora /input-cache; _updatePublisher scripts e build.yml baixam publisher.jar de https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar |
| REA-DKSMART-002 | Ausente | Nenhum teste automatizado de arquivos FSH ou validação do IG | CONFIRMADO (estática) | P3 | Nenhum arquivo de teste encontrado no repositório |
| REA-DKSMART-003 | `instances.fsh:16` | URL hardcoded para servidor de exemplo externo (gravitate-ips.gravitate.tcs.trifork.dev) → dependência de serviço externo que pode ficar indisponível | HIPÓTESE | P3 | Linha 16: `url = "https://gravitate-ips.gravitate.tcs.trifork.dev/fhir/metadata"` e linhas 29,32 com OAuth URIs do mesmo domínio |
| REA-DKSMART-004 | `dk-smart-server.fsh:7` | Data hardcoded "2023-11-09" no CapabilityStatement instance → pode ficar desatualizada sem revisão | HIPÓTESE | P3 | Linha 7: `date = "2023-11-09"` |
| REA-DKSMART-005 | `sushi-config.yaml:52-57` | version 1.1.0 com status: draft e releaseLabel: ci-build → inconsistência entre versão estável e status de desenvolvimento | HIPÓTESE | P3 | Linha 52: `version: 1.1.0`, linha 55: `status: draft`, linha 57: `releaseLabel: ci-build` |

### Sem problemas P0 ou P1
Nenhum problema crítico confirmado.

---

## C. Problemas recorrentes
Issues no GitHub:
- #1: "Clarify text on MinLog" (CLOSED)
- #2: "Consider restriction on the use of symmetric keys" (CLOSED)
- #3: "Best practices from FAPI" (OPEN)
- #4: "Describe link to DK Core and IPA" (CLOSED)

Não há PRs abertos ou fechados. Não foram identificadas regressões documentadas. O problema #3 (FAPI best practices) permanece aberto e pode estar relacionado à segurança de autorização.

---

## D. Erros não documentados
REA-DKSMART-001 a REA-DKSMART-005 não estavam documentados em issues/PRs.

---

## E. Performance
Não há oportunidades de performance relevantes em um IG FHIR (build executado externamente via IG Publisher/CI).

---

## F. Melhorias técnicas
1. Versionar publisher.jar ou documentar claramente o processo de download (REA-DKSMART-001)
2. Adicionar testes automatizados de validação FSH/IG (REA-DKSMART-002)
3. Substituir URL hardcoded de servidor externo por variável de configuração ou exemplo local (REA-DKSMART-003)
4. Atualizar data do CapabilityStatement ou torná-la automática (REA-DKSMART-004)
5. Alinhar version 1.1.0 com status apropriado (draft vs active) e releaseLabel (REA-DKSMART-005)
6. Adicionar CODEOWNERS ou CONTRIBUTING.md para orientar contribuições

---

## G. Plano de execução
Todas as melhorias são independentes e de baixo risco, mas não há código-fonte complexo para corrigir. São melhorias de infraestrutura de build e documentação.

---

## H. Resultado esperado
Build mais reproduzível, testes de validação, remoção de dependência de servidor externo, documentação clara de onboarding.

---

## Análise de malware e ameaças (estática)
**Resultado:** Nenhum indicador identificado pela análise estática realizada.
- Apenas arquivos de configuração (YAML, INI, FSH, MD, JSON), scripts de build (BAT, SH), workflow CI/CD e imagens
- Os scripts de build e workflow fazem download do publisher.jar de https://github.com/HL7/fhir-ig-publisher/releases/ (fonte oficial HL7) — chamada de rede legítima
- instances.fsh referencia URLs de servidor de exemplo (gravitate-ips.gravitate.tcs.trifork.dev) e smarthealthit.org — fontes públicas FHIR legítimas, não credenciais
- Nenhuma credencial, chave, token ou senha embutida
- Nenhum comando de shell suspeito, subprocess, exec, eval, persistência, ofuscação ou exfiltração de dados
- Não se afirma que o projeto está livre de malware

---

## Perguntas finais obrigatórias
1. **Bugs críticos comprovados?** Nenhum P0/P1.
2. **Problemas repetitivos não resolvidos?** Não há histórico suficiente de regressões. Issue #3 (FAPI best practices) permanece aberto.
3. **Erros importantes não documentados?** publisher.jar não versionado, sem testes automatizados, URL hardcoded de servidor externo, data hardcoded no CapabilityStatement, inconsistência versão/status/releaseLabel.
4. **Oportunidades de performance?** Nenhuma relevante.
5. **Melhorias de segurança/confiabilidade justificáveis?** Versionar publisher.jar, adicionar CI/CD testes, remover dependência de servidor externo hardcoded, documentar onboarding.
6. **Correções rápidas?** Documentar publisher.jar, atualizar data do CapabilityStatement, alinhar versão/status/releaseLabel.
7. **Três contribuições de maior valor?** (a) Testes de validação FSH/IG, (b) CI/CD já existe, melhorar documentação de onboarding (publisher.jar), (c) remover dependência de servidor externo.
8. **Correções a evitar por falta de evidência?** Nenhuma — todas são melhorias de infraestrutura bem fundamentadas.
9. **Modificações recomendadas primeiro?** Documentação de onboarding (publisher.jar) e testes de validação FSH.
