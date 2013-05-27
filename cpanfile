requires 'perl', '5.008001';

requires 'Getopt::Long';
requires 'Config::PL';
requires 'Path::Tiny';
requires 'Class::Accessor::Lite::Lazy';

on build => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Requires', '0.06';
};
