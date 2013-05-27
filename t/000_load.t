#!perl -w
use strict;
use Test::More tests => 1;

BEGIN {
    use_ok 'Dist::Maker::FromProject';
}

diag "Testing Dist::Maker::FromProject/$Dist::Maker::FromProject::VERSION";
