#!/bin/sh
cd `dirname $0`
exec erl -config sys.config -pa $PWD/_build/default/lib/*/ebin $PWD/test -boot start_sasl -setcookie start-dev -args_file vm.args -s butler_app