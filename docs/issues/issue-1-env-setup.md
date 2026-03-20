## 背景・目的
Windows PC上のLDPlayer（Androidエミュレーター）に対してPythonからADB経由で操作できる基盤を構築する。
この基盤がすべての後続Issueの土台となる。

## 要件

### やること
- Pythonプロジェクト構成の初期化（requirements.txt、ディレクトリ構成）
- LDPlayerのADB接続設定ドキュメント（README手順）
- ADB接続確認スクリプトの作成（接続OK/NGを標準出力）
- スクリーンショット取得の動作確認（1枚保存できること）
- タップ送信の動作確認（指定座標をタップできること）

### やらないこと
- ゲーム固有の処理
- 画像認識ロジック

## 完了条件（DoD）
- [ ] `pip install -r requirements.txt` でエラーなく依存関係が入る
- [ ] `python src/check_adb.py` を実行するとADB接続状態がCLIに表示される
- [ ] スクリーンショットが `logs/` 以下に保存される
- [ ] 指定座標へのタップがエミュレーター上で反映される
- [ ] README.mdにLDPlayer設定手順が記載されている

## 未確定事項・要確認事項
- なし（LDPlayerを使用することで確定）
