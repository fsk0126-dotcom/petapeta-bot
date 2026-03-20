## 背景・目的
すべてのアクションモジュールをステートマシンで統合し、自動周回メインループを実装する。
CLIで周回回数をリアルタイム表示する。

## 要件

### やること
- `AutoRunner` クラスの実装（メインFSM）
  - ループ処理：`detect_state → select_action → execute → repeat`
  - 対応ステート：FIELD / DUNGEON / SUMMON_AVAILABLE / ENHANCE_AVAILABLE / STAGE_RESULT / STAGE_START / UNKNOWN
- **ステージ終了後の動作モード（選択可能）**：
  - `mode: auto` → 結果画面を閉じて次のステージを自動開始
  - `mode: manual` → 結果画面を検出したらBOTを停止
  - `config.yaml` の `restart_mode` で切り替え
- BOT起動からの**周回回数**をCLIにリアルタイム表示
  - 例：`[周回: 42回] [状態: ENHANCE_AVAILABLE] [経過: 01:23:45]`
- `UNKNOWN` 状態が連続N回（設定値）続いたら自動リカバリ（スクリーンショット保存 → 待機）
- Ctrl+Cで安全に停止できる

### やらないこと
- GUI（CLIのみ）
- 周回データの永続保存

## 完了条件（DoD）
- [ ] `python src/main.py` でBOTが起動しCLIにステータスが表示される
- [ ] 周回回数がステージ完了のたびにカウントアップされる
- [ ] `config.yaml` の `restart_mode: auto/manual` で動作が切り替わる
- [ ] `UNKNOWN` 連続検出時にリカバリ処理が走りフリーズしない
- [ ] Ctrl+C で「BOT停止: 周回N回」と表示されて終了する

## 依存Issue
- Issue #3（画面状態検出）
- Issue #4（フィールド配置）
- Issue #5（ダンジョン配置）
- Issue #6（召喚ロジック）
- Issue #7（強化ロジック）
