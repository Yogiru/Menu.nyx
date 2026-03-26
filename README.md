# Nyx.ps1(menu)
# Menu for Nyx.ps1

Repository: [https://github.com/evilsocket/nyx](https://github.com/evilsocket/nyx) [web:31]

## English

- **nyx_Menu_En.bat** – interactive launch menu for Nyx Cleaner that lets you run dry‑run, normal or force clean, advanced wipes (including `hiberfil.sys` / `pagefile.sys`), debug mode, and specific anti‑forensics modules via `nyx.ps1`. [web:31]  
- **nyx_Menu_Ru.bat** – Russian‑localized console menu for Nyx Cleaner providing the same cleaning modes and modular selection, plus quick language switching between English and Russian launchers. [web:31]

## Русский

- **nyx_Menu_Ru.bat** — консольное меню запуска Nyx Cleaner на русском языке, позволяющее выбирать режим очистки (тестовый, обычный, принудительный, расширенный), включать подробный вывод и запускать отдельные модули анти‑форензики через `nyx.ps1`. [web:31]  
- **nyx_Menu_En.bat** — англоязычное меню для управления Nyx Cleaner: выбор сухого запуска, нормальной или форсированной очистки, расширенных сценариев (включая очистку `hiberfil.sys` и `pagefile.sys`), режима отладки и запуска конкретных модулей очистки следов. [web:31]
​


---

# 🧠 Что это вообще

Cкрипт nyx.ps1 это **PowerShell-скрипт для антифорензики** — утилита *Nyx*, которая:

> ❗ **целенаправленно удаляет следы активности в Windows**

Причём довольно агрессивно: логи, кеши, историю, реестры, артефакты безопасности и даже системные базы.

---

# ⚙️ Архитектура

## 1. Параметры запуска



Основные флаги:

* `-DryRun` → ничего не удаляет, только показывает
* `-Debug` → подробный вывод
* `-Modules` → выбор модулей (через запятую)
* `-Force` → без подтверждения
* `-Advanced` → **опасный режим (глубокая чистка)**
* `-LogFile` → логирование

👉 Уже на этом этапе видно: инструмент сделан и для безопасного теста, и для жёсткого вайпа.

---

## 2. Глобальная логика

* строгий режим (`Set-StrictMode`)
* счётчики:

  * `$CLEANED_COUNT`
  * `$FAILED_COUNT`
* универсальные функции:

  * `Safe-Remove`
  * `Truncate-File`
  * логирование (Info / Debug / Error)

👉 Код написан аккуратно, с обработкой ошибок и fallback’ами.

---

# 🧩 Модули очистки

## 🔹 1. `events`

Чистит:

* все Windows Event Logs (через `wevtutil`)
* критические логи (Application, System, Security)

👉 Это уже ломает аудит системы.

---

## 🔹 2. `history`

Удаляет:

* PowerShell history
* CMD history
* Run (Win+R)
* Prefetch
* Jump Lists
* Timeline
* поиск Windows
* браузер Edge / IE

👉 Полное стирание пользовательской активности.

---

## 🔹 3. `registry`

Чистит:

* MRU (recent files)
* USB история
* MountedDevices
* BAM (Background Activity Monitor)
* ShimCache (очень важен для форензики)

👉 Это уже уровень **anti-forensics**, не просто “чистка”.

---

## 🔹 4. `filesystem`

Удаляет:

* USN Journal (!!!)
* корзину
* thumbcache
* SRUDB (системная база активности)
* Windows.edb (индекс поиска, в Advanced)

👉 Особенно опасно:

* `fsutil usn deletejournal` — убивает журнал файловой системы

---

## 🔹 5. `temp`

Очень жирный модуль:

* TEMP папки
* DNS cache
* Shadow copies (restore points ❗)
* crash dumps
* Defender history
* firewall logs
* network caches
* OneDrive / Teams / Outlook / WSA / Xbox

👉 Это уже зачистка почти всех следов ОС.

---

## 🔹 6. `security`

Удаляет логи:

* McAfee
* Symantec
* CrowdStrike
* SentinelOne
* Carbon Black

👉 То есть:

> ❗ направлено на обход EDR / AV анализа

---

## 🔹 7. `advanced`

Удаляет:

* сертификаты
* scheduled tasks
* сервисы
* Wi-Fi профили
* VPN
* Chrome extensions
* crypto ключи

👉 Это уже **операционный уровень скрытия следов**

---

# ⚠️ Ключевые риски

## 🚨 1. Необратимость

В коде прямо сказано:

> “This action cannot be undone”

И это правда:

* удаляются системные базы
* удаляются журналы
* ломаются механизмы восстановления

---

## 🚨 2. Потеря стабильности

Особенно:

* Prefetch
* Windows.edb
* Shadow Copies
* Registry ключи

---

## 🚨 3. Форензика ломается

Скрипт целенаправленно бьёт по:

* USN Journal
* ShimCache
* BAM
* Event Logs

👉 Это именно то, что используют расследования.

---

## 🚨 4. Требует админ-доступ

```powershell
Check-Privileges
```

Без этого — не работает.

---

# 🧠 Что сделано хорошо

✔ Обработка ошибок
✔ DryRun режим
✔ Модульность
✔ Логирование
✔ Восстановление ACL (редкий плюс)

👉 Это не “скрипт на коленке”, а довольно продуманная утилита.

---

# 💀 Что настораживает

* Чистка EDR логов
* Удаление USN journal
* Работа с BAM / ShimCache
* Массовый wipe registry

👉 Это уже не “оптимизация системы”, а:

> **инструмент сокрытия активности**

---

# 📊 Итог

**Nyx = мощный anti-forensics cleaner**

### Уровень:

* 🟢 обычная чистка → CCleaner
* 🟡 продвинутая → BleachBit
* 🔴 Nyx → **forensic evasion tool**

---

# Если кратко

👉 Скрипт:

* стирает почти все цифровые следы в Windows
* работает на уровне ОС и реестра
* может повредить систему
* используется там, где важно **не оставить следов**

---
