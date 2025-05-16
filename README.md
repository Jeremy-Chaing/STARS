
# STARS 專案需求說明文件

## 專案名稱
Storage Tracking And Rentals System (STARS)

## 專案概述
Athens U-Store 是一家位於美國喬治亞州的自助倉儲租賃公司，擁有多個遍佈全國的倉儲設施。為了提升租賃管理效率，公司決定在 NAVISION Financials 基礎上，建立一個集中化的租賃管理系統。

## 專案目標
1. 集中管理所有倉儲設施的客戶租賃資料。
2. 建立子系統以追蹤押金、租金和退還記錄。
3. 生成各個倉儲設施的每週活動報告。
4. 確保系統與總帳系統隔離，降低系統複雜度。

## 功能需求
### 1. 押金管理
- 支援客戶在租賃開始時輸入押金。
- 押金金額須為正數，且每平方英尺的最大金額為 $5。

### 2. 每月租金追蹤
- 記錄每月的租金費用。
- 支援根據租賃期間自動計算應收租金。

### 3. 退還管理
- 記錄並追蹤退還給客戶的押金。
- 退還金額預設為負數，每平方英尺最多 $5。

### 4. 倉儲活動報告
- 每週生成倉儲活動報告。
- 以倉儲單元和日期分組，包含每日小計和倉儲單元總計。

### 5. 客戶列表報告
- 列出所有客戶及其相關的倉儲單元。
- 提供詳細或摘要格式列印選項。
- 支援篩選 **Customer No.**、**Customer City** 和 **Date**。

### 6. FlowFields 設定
- 為 **Customer** 和 **Storage Unit** 表增加 FlowFields：
  - **累計租金費用**（排除押金和退還押金）。
  - **平均押金**（排除租金費用和退還押金）。

### 7. STARS 選單
- 建立 STARS 選單，包含以下功能：
  - 倉儲單元管理
  - 建築管理
  - 日記帳管理
  - 活動報告
  - 客戶列表報告
- 與 Navision 主選單整合，增加 **STARS** 按鈕。

## 系統設計
### 1. 資料表
- **Storage Unit (99940)**
- **Building (99942)**
- **Storage Journal (99943)**
- **Storage Ledger Entry (99944)**

### 2. 表單
- **Storage Unit Card (99940)**
- **Storage Unit List (99941)**
- **Buildings (99942)**
- **Storage Ledger Entries (99944)**

### 3. 報表
- **Storage Unit Activity by Date (99940)**
- **Active Customer List (99941)**

### 4. 程式碼單元
- **Stor. Jnl. Line – Check Line (99941)**
- **Stor. Jnl. Line – Post Line (99942)**
- **Stor. Jnl. Line – Post Batch (99943)**

## 系統限制
- 不與總帳系統直接整合。
- 系統需具備可擴展性，以支援未來擴展。

## 專案負責人
- **客戶：** Athens U-Store
- **專案負責人：** Jack Hodgson
