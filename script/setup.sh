#!/bin/sh

PERL_AUTOINSTALL=--defaultdeps LANG=C cpanm --installdeps --notest . < /dev/null
mysqladmin -uroot create hatena_newbie
mysql -uroot hatena_newbie < db/schema.sql

mysqladmin -uroot create hatena_newbie_test
mysql -uroot hatena_newbie_test < db/schema.sql
