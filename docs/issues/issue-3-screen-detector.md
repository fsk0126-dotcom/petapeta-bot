## 背景・目的
ゲーム画面をスクリーンショットで取得し、OpenCVテンプレートマッチングで「現在どの画面状態か」を判定するモジュールを実装する。
ステートマシン（Issue #8）がこの判定結果をもとに次のアクションを決定する。

## 要件

### やること
- `ScreenAnalyzer` クラスの実装
  - `detect_state(screen)` → 現在の画面状態を `GameState` Enumで返す
- 検出対象の画面状態（GameState）：
  - `FIELD` : メインフィールド（18マス画面）
  - `DUNGEON` : ダンジョン画面（6枠画面）
  - `SUMMON_AVAILABLE` : 召喚ボタンが押せる状態
  - `ENHANCE_AVAILABLE` : 強化ボタンが押せる状態（幸運コイン充足）
  - `STAGE_RESULT` : ステージ終了・結果画面
  - `STAGE_START` : ステージ開始前の画面
  - `UNKNOWN` : 上記に該当しない状態
- 各状態のテンプレート画像を `src/templates/` に配置する手順をREADMEに記載
- 検出スコア（confidence）が閾値未満の場合は `UNKNOWN` を返す
- 閾値は `config.yaml` で設定可能にする

### やらないこと
- アクションの実行
- OCRによるテキスト読み取り

## 完了条件（DoD）
- [ ] `ScreenAnalyzer.detect_state()` が `GameState` Enumを返す
- [ ] 各画面のテンプレート画像が `src/templates/` に存在する
- [ ] 実画面スクリーンショットに対して正しいStateが返ることを手動テストで確認
- [ ] テンプレートが見つからない場合 `UNKNOWN` を返し、エラーで落ちない
- [ ] 閾値は `config.yaml` から読み込まれる

## 未確定事項・要確認事項
- テンプレート画像はユーザーが実機から切り出して配置する（実装後に収集作業が必要）

## 依存Issue
- Issue #2（ADBユーティリティ）
