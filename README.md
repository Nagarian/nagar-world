# Nagarian's blog

## Importer les posts depuis wordpress

```bash
apk update
apk add mariadb-dev
gem install jekyll-import sequel unidecode mysql2
ruby -rubygems -e 'require "jekyll-import";
JekyllImport::Importers::WordPress.run({
    "dbname"   => "",
    "user"     => "",
    "password" => "",
    "host"     => "",
    "port"     => "3306",
    "socket"   => "",
    "table_prefix"   => "wp_",
    "site_prefix"    => "",
    "clean_entities" => true,
    "comments"       => true,
    "categories"     => true,
    "tags"           => true,
    "more_excerpt"   => true,
    "more_anchor"    => true,
    "extension"      => "md",
    "status"         => ["publish"]
})'
```