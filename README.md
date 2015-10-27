# Hatena::Newbie

(newbie) `script/generate Project::Name` : 雛形のインスタンスを生成

## セットアップ
以下のコマンドを実行。
```
$ script/setup_db.sh
```

## サーバ起動
以下のコマンドでサーバが起動できる。デフォルトでは http://localhost:3000/ にアクセスすれば良い。
```
$ script/appup
```

## API

### `$c`
- `Hatena::Newbie::Context`
- コンテキストという名が示すように、ユーザーからのリクエストにレスポンスを返すまでに最低限必要な一連のメソッドがまとめられている

### `$c->req`
- リクエストオブジェクトを返す
- [`Plack::Request`](http://search.cpan.org/dist/Plack/lib/Plack/Request.pm)を継承した`Hatena::Newbie::Request`

### `$c->req->parameters->{$key}`
- `$key`に対応するリクエストパラメーターを返す
- クエリパラメーターやルーティングによって得られたパラメーターなど全てが対象となる

### `$c->dbh`
- データベースのハンドラを返す
- [`DBIx::Sunny`](http://search.cpan.org/dist/DBIx-Sunny/lib/DBIx/Sunny.pm)

### `$c->html($template_file, $parameters)`
- ファイル名とテンプレート変数を受け取ってレンダリングされたHTMLをレスポンスに設定する
```perl
$c->html('index.html', { foo => $bar });
```

### `$c->json($object)`
- ハッシュリファレンスを受け取ってJSON文字列化したものをレスポンスに設定する
```perl
$c->json({ spam => $egg });
```

### `$c->throw_redirect($url)`
- 大域脱出して渡されたURLにリダイレクトする
```perl
$c->throw_redirect('/');
```

### `$c->res`
- レスポンスオブジェクトを返す
- [`Plack::Response`](http://search.cpan.org/dist/Plack/lib/Plack/Response.pm)
