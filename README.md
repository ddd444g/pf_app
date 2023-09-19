# Go To place
## URL
<p><a href="https://gone-place.com/" target="_blank">https://gone-place.com</a></p>
## アプリ概要
- **行きたい場所を登録できます**
  - サイト内のマップで検索して、行きたい場所の Google マップでの情報を取得し登録できます。

- **訪問した場所はレビューを残して登録できます**
  - 訪問した場所は自分だけのレビューと点数を付けて登録出来ます。
  - もう一度行きたい場所はワンクリックで「もう一度行きたい」に登録できます。
  - 行きたい場所に登録してない場所も、訪問した場所に登録できます。

- **予定を作成し訪問予定場所を登録できます**
  - 登録済みの行きたい場所やもう一度行きたい場所を、訪問予定場所として予定に追加できます。
  - 行きたい場所の訪問予定時刻も決められます。
  - 行きたい場所の予定時刻や、googlemapでのratingも一覧で見れるので、旅行やデートの計画の際に役立ちます。
  
- **おすすめ場所は他の人に公開できます**
  - 訪問済みに登録している場所をおすすめに公開できます。
  - 他の人のおすすめ場所は、行きたい場所へ保存することができます。
  
## 使用技術
- フロントエンド
  - HTML
  - tailwind css 2.2
  - alpine.js 2.8.2
  - Google Maps API

- バックエンド
  - ruby 2.7.3
  - rails 6.1.7

- テスト
  - rspec(Capybara,selenium_chrome)

- インフラ
  - CircleCI
  - Docker
  - nginx
  - unicorn
  - mysql
  - AWS ( EC2, ALB, ACM, Route53, VPC )

- 自動デプロイツール
  - Capistrano

- 静的コード解析
  - rubocop-airbnb

## インフラ図
![](/aws.png)
