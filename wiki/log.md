# 知識庫維護與操作日誌 (Log)

本文件以時序方式記錄知識庫的所有變更（Ingest 來源攝入、Query 深度問答、Lint 健檢與簡報生成）。

---

## [2026-11-24] Init | 專案初始化與結構建立
- 依據 Karpathy LLM Wiki 模式建立 `raw/`, `wiki/`, `presentations/` 基礎架構。
- 完成專用規則手冊 `AGENTS.md`，定義《謎魅狩獵》怪物實體的三大戰術核心維度（攻擊方式、避戰方式、反擊方式）。
- 初始化 `wiki/index.md` 與 `wiki/log.md`。


## [2026-11-24] Ingest | 全面批次攝入 10 隻 Mimesis 怪物實測檔案
- 讀取 `raw/` 內 10 份原始資料：`Mimesis`, `Bombesis`, `Brute Bunny`, `Mama Monkey`, `Quakka Glider`, `Standing Owl`, `Maegoostro`, `Heavy D`, `Sentryper`, `Ramblam`。
- 遵循 `AGENTS.md` 規範，建立 10 份獨立實體檔案 (`wiki/entities/*.md`)，詳盡補完【攻擊方式】、【避戰方式】、【反擊方式】。
- 提煉 4 大核心機制文件 (`wiki/mechanics/`)：擬態欺詐、聲音感知、視線凝視制約、怪物連攜連鎖。
- 提煉 2 大戰術指引文件 (`wiki/tactics/`)：全怪物避戰指南、武器彈藥經濟評析。
- 全面更新 `wiki/index.md` 索引總目錄。


## [2026-11-24] Correction | 修正 Mimesis 武裝機制（物品欄鏡像複製）
- 依據玩家精確指正：Mimesis 面對玩家時，是**直接複製玩家四格物品欄**；若玩家物品欄內帶有武器，它會掏出複製出來的同款武器反制，**並非搶奪或繳械玩家手中拿著的武器**。
- 同步修正檔案：
  - `wiki/entities/mimesis.md`
  - `wiki/mechanics/mimicry_and_deception.md`
  - `wiki/tactics/weapon_and_gear.md`
  - `wiki/tactics/general_evasion.md`
  - `wiki/index.md`
  - `presentations/index.html` (更新威脅矩陣、實體專頁與戰術總結投影片)
