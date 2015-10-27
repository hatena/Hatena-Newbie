#!/bin/sh

ROOT="$(cd $(dirname "$0")/..; pwd)"
cd "$ROOT"

mysql="mysql $@"
project="hatena_newbie"
user="nobody"

find_user () {
    sql="SELECT 1 FROM mysql.user WHERE user = '$1'"
    [ "$($mysql -N -uroot -e "$sql")" = '1' ] || return 1
    return 0
}

create_db () {
    name="$1"
    $mysql -uroot -e "DROP DATABASE IF EXISTS $name; CREATE DATABASE $name"
    for sql in `ls db/*.sql`; do
        [ -r "$sql" ] && {
            $mysql -uroot "$name" < "$sql"
            echo -n '.'
        }
    done
}

find_user "$user" || {
  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$user'@'localhost' IDENTIFIED BY '$user' WITH GRANT OPTION"
  echo "User $user@localhost ($user) created"
}

echo -n 'Setting up DB '
create_db "$project"
create_db "${project}_test"
echo ' done'
