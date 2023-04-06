## 現在の状況
- dockerで開発環境を構築
- circleciを導入(rspecとrubocopを実施)
- 最低限の機能でいいので、一旦AWS ec2上にデプロイしようと思い最低限のコードでデプロイしました。
  - UserのCRUD処理
  - 行きたい場所のCRUD処理
  - 訪問済み場所のCRUD処理 + もう一度行きたいに登録,解除機能(boolean型で切り替え)
  - ログイン機能
  - ゲストログイン機能
- AWS ec2にデプロイし独自ドメインを取得しhttps化しました。
- Capistranoを導入し、ec2に自動デプロイ出来るようにしました。
- デザインは軽く整えているだけです。
- テストもrspecを導入しただけで、書いていません

__最低限の土台が出来たと思っています。ここから改善、追加をして行こうと思っています__

***ただ、その前にこのまま進んでいいのか不安なので一旦アドバイスを頂きたいです。***
- 下記の、今後追加したいもの以外で追加するべき機能
- そもそもアプリ自体を作り直した方がいいのか
- このまま改善、追加に進んでもいいのかどうか

***よろしくお願い致します***

## 今後追加したいもの
- reactの導入（SPAにするのではなく、gemでの導入）
- cssフレームワーク（Tailwind）
- テストを必要十分な量書く
- デザインを整える。
- レスポンシブ対応
- googlemap APIで位置情報だけでなく、その場所の情報(レビュー、営業時間等)も取得したい
- おすすめの場所の投稿機能
- 他人のおすすめの場所を自分の行きたい場所として保存する機能
- 他人のおすすめの場所に対して、いいね,コメントする機能
- リファクタリング
- readmeをきちんと書く
- インフラ図も綺麗に描き直す

## アプリ概要
- 行きたい場所を保存しておく
- 行きたい場所に訪問したら、その場所を訪問した場所に登録し、行きたい場所からは削除
- 訪問した場所をレビューと点数を付けて保存する
- 行きたい場所に登録してない場所も、訪問した場所に登録できる
- 訪問した場所でもう一度行きたい場所は、もう一度行きたい場所として保存する
- アプリのイメージは、todoアプリのタスクを管理するのではなく、行きたい場所,訪問済みの場所を管理するアプリのイメージです。

## 使用技術
- フロントエンド
  - HTML/CSS/Haml/Sass
  - Google Maps API

- バックエンド
  - ruby 2.7.3
  - rails 6.1.7

- テスト
  - rspec

- インフラ
  - CircleCI
  - Docker
  - nginx
  - mysql
  - AWS ( EC2, ALB, ACM, Route53, VPC )

- 自動デプロイツール
  - Capistrano

- 静的コード解析
  - rubocop-airbnb

## インフラ図
![](/aws.png)
