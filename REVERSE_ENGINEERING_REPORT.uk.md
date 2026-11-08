# REVERSE_ENGINEERING_REPORT.uk.md (Українська)

Примітка: переклад технічний, виконаний з автоматичною допомогою; рекомендується перегляд rodsnym мовцем перед використанням як нормативного довідника.

## Цільовий репозиторій
- **Назва:** dk-smart
- **URL:** https://github.com/hl7dk/dk-smart
- **Гał diff гałку (upstream):** master
- **Базовий коміт для аналізу:** 29e5bd0 (Update publication-request.json)
- **Версія проєкту:** 1.1.0 (sushi-config.yaml), статус draft
- **Локальна робоча тека:** C:\Users\User\audit-repos\dk-smart
- **Тека аудиту:** C:\Users\User\audit-repos\audit-work
- **Дата/час аудиту:** 2026-11-08 (місний час)
- **Середовище:** Windows, PowerShell 5.1, Git 2.49.0, Python 3.12.14 (без SUSHI/IG Publisher встановлених)

---

## А. Загальний діагноз

### Виявлена архітектура
FHIR R4 Implementation Guide (IG) для Danish SMART App Launch, побудований з SUSHI (FHIR Shorthand). IG надає рекомендації щодо використання механізму SMART App Launch в Данії.

Структура:
- `sushi-config.yaml` — конфігурація IG (id, canonical, name, version 1.1.0, залежності, сторінки, меню, releaseLabel: ci-build)
- `ig.ini` — вказує на згенерований ImplementationGuide у fsh-generated/resources/, шаблон https://github.com/hl7dk/dk-ig-template
- `input/fsh/` — 3 файли FSH: dk-smart-server-profile.fsh (Профіль CapabilityStatement), dk-smart-server.fsh (Екземпляр CapabilityStatement), instances.fsh (Екземпляр example-ipa-server)
- `input/pagecontent/` — 4 сторінки Markdown: index.md, conformance.md, examples.md, downloads.md
- `input/includes/` — fragment-footer.html
- `input/ignoreWarnings.txt` — придушення попереджень валідатора
- Скрипти збирання: _genonce.sh/.bat, _gencontinuous.sh/.bat, _updatePublisher.sh/.bat
- `.github/workflows/build.yml` — CI/CD через GitHub Actions (Docker hl7fhir/ig-publisher-base, завантаження publisher.jar, збирання IG, розгортання GitHub Pages)
- `.gitignore` — ігнорує /fsh-generated, /input-cache, /output, /temp, /template, /temp-publish, /web-root
- `LICENSE` — CC0 1.0 Universal
- `publication-request.json` — метадані для публікації на build.fhir.org

### Технології та залежності
- SUSHI (FHIR Shorthand)
- FHIR R4 (fhirVersion: 4.0.1)
- Залежності: hl7.fhir.uv.ipa 1.0.0, hl7.fhir.uv.smart-app-launch 2.2.0
- IG Publisher (publisher.jar, завантажується через CI, не версійований у Git)
- Java (для запуску publisher.jar)
- Node.js (workflow GitHub Actions)
- Ліцензія: CC0-1.0

### Стан підтримки
- Активний: версія 1.1.0 draft, декілька нещєвих комітів
- Останній коміт: 29e5bd0 (Update publication-request.json)
- Публічний збір: https://build.fhir.org/ig/hl7dk/dk-smart
- CI/CD налаштовано: GitHub Actions (build.yml) з розгортанням GitHub Pages
- Немає автоматизованих тестів

### Існуючі механізми тестування
- Немає автоматизованих тестів коду
- Валідація через IG Publisher (зовнішній, у CI)
- ignoreWarnings.txt для придушення відомих попереджень

### Обмеження дослідження
- SUSHI та IG Publisher не встановлені → неможливо виконати збирання IG локально
- Аналіз засновано на статичному огляді конфігурації YAML, файлів FSH, скриптів збирання та workflow CI/CD

---

## Б. Виявлені проблеми

| ID | Місцезнаходження | Проблема | Статус | Середність | Докази |
|----|------------------|----------|--------|------------|----------|
| REA-DKSMART-001 | `_genonce.sh/.bat`, `_updatePublisher.sh/.bat`, `.github/workflows/build.yml:36` | `publisher.jar` не версійований у Git → збирання залежить від завантаження вручну або CI для отримання publisher.jar | ПІДТВЕРДЖЕНО (статично) | P2 | .gitignore ігнорує /input-cache; скрипти _updatePublisher та build.yml завантажують publisher.jar з https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar |
| REA-DKSMART-002 | Відсутнє | Немає автоматизованих тестів для файлів FSH або валідації IG | ПІДТВЕРДЖЕНО (статично) | P3 | Немає файлів тестів у репозиторії |
| REA-DKSMART-003 | `instances.fsh:16` | Жорстко закодований URL до зовнішнього прикладу сервера (gravitate-ips.gravitate.tcs.trifork.dev) → залежність від зовнішнього сервісу, що може стати недоступним | ГІПОТЕЗА | P3 | Рядок 16: `url = "https://gravitate-ips.gravitate.tcs.trifork.dev/fhir/metadata"` та рядки 29,32 з OAuth URI з того ж домену |
| REA-DKSMART-004 | `dk-smart-server.fsh:7` | Жорстко закодована дата "2023-11-09" в екземплярі CapabilityStatement → може застаріти без перегляду | ГІПОТЕЗА | P3 | Рядок 7: `date = "2023-11-09"` |
| REA-DKSMART-005 | `sushi-config.yaml:52-57` | version 1.1.0 зі статусом draft та releaseLabel: ci-build → несумісність між стабільною версією та станом розробки | ГІПОТЕЗА | P3 | Рядок 52: `version: 1.1.0`, рядок 55: `status: draft`, рядок 57: `releaseLabel: ci-build` |

### Проблеми P0 або P1 не підтверджені
Жодної критичної проблеми не підтверджено.

---

## В. Повторні проблеми
Проблеми GitHub:
- #1: "Clarify text on MinLog" (ЗАКРИТО)
- #2: "Consider restriction on the use of symmetric keys" (ЗАКРИТО)
- #3: "Best practices from FAPI" (ВІДКРИТО)
- #4: "Describe link to DK Core and IPA" (ЗАКРИТО)

Немає відкритих або закритих PR. Задокументованих регресій не виявлено. Проблема #3 (FAPI best practices) залишається відкритою і може стосуватися безпеки авторизації.

---

## Г. Недокументовані помилки
REA-DKSMART-001 до REA-DKSMART-005 не були задокументовані в проблемах або PR.

---

## Д. Продуктивність
Немає відповідних можливостей продуктивності у FHIR IG (збирання виконується зовнішньо через IG Publisher/CI).

---

## Е. Технічні вдосконалення
1. Версія publisher.jar або чітке документування процесу завантаження (REA-DKSMART-001)
2. Додати автоматизовані тести валідації FSH/IG (REA-DKSMART-002)
3. Замінити жорстко закодований URL зовнішнього сервера на змінну конфігурацію або приклад локальний (REA-DKSMART-003)
4. Оновити дату CapabilityStatement або зробити її автоматичною (REA-DKSMART-004)
5. Вирівняти версію 1.1.0 зі статусом (draft vs active) та releaseLabel (REA-DKSMART-005)
6. Додати CODEOWNERS або CONTRIBUTING.md для ориєнтації внесків

---

## Є. План виконання
Усі вдосконалення є незалежними і мають низький ризик, але немає складного вихідного коду для виправлення. Це вдосконалення інfrakstrukturi збирання та документації.

---

## Ї. Очікуваний результат
Більш відтворюване збирання, тести валідації, приbranня залежності від зовнішнього сервера, чітка документація запуску.

---

## Аналіз програмного засіба та загроз (статичний)
**Результат:** Жодного показника не виявлено статичниманалiзом, що було проведено.
- Лише конфігураційні файли (YAML, INI, FSH, MD, JSON), скрипти збирання (BAT, SH), workflow CI/CD та зображення
- Скрипти збирання та workflow завантажують publisher.jar з https://github.com/HL7/fhir-ig-publisher/releases/ (офіційне джерело HL7) — легітивний мережевий виклик
- instances.fsh посилається на URL прикладу сервера (gravitate-ips.gravitate.tcs.trifork.dev) та smarthealthit.org — публічні джерела FHIR, не облікові дані
- Немає облікових даних, ключів, токенів або паролів, вбудованих у код
- Немає підозрілих команд оболонки, subprocess, exec, eval, стійкості, обфускації або екстракції даних
- Не заявляється, що проєкт є безшкідним.

---

## Обов'язкові питання на завершення
1. **Які критичні помилки підтверджено?** Жодної P0/P1.
2. **Які повторні проблеми ще не вирішені?** Недостатньо історії регресій. Проблема #3 (FAPI best practices) залишається відкритою.
3. **Які важливі помилки не були задокументовані?** publisher.jar не версійований, немає автоматизованих тестів, жорстко закодований URL зовнішнього сервера, жорстко закодована дата CapabilityStatement, несумісність версії/статусу/releaseLabel.
4. **Які можливості продуктивності виявлено?** Жодних відповідних.
5. **Які вдосконалення безпеки та надійності обґрунтовані?** Версія publisher.jar, додати тести CI/CD, прибрати жорстко закодовану залежність від зовнішнього сервера, документувати запуск.
6. **Які виправлення можна зробити швидко?** Документувати publisher.jar, оновити дату CapabilityStatement, вирівняти версію/статус/releaseLabel.
7. **Які є три внески з найбільшою технічною цінністю?** (а) тести валідації FSH/IG, (б) CI/CD вже існує, покращити документацію запуску (publisher.jar), (в) прибрати залежність від зовнішнього сервера.
8. **Які виправлення слід уникати через відсутність доказів?** Жодних — усі є добре обґрунтованими вдосконаленнями інfrakstrukturi збирання.
9. **Які зміни ви рекомендуєте реалізувати першими?** Документація запуску (publisher.jar) та тести валідації FSH.
