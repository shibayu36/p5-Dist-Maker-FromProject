package Dist::Maker::FromProject;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

use Config::PL;
use Path::Tiny;
use Class::Accessor::Lite::Lazy (
    new     => 1,
    ro      => [qw(class_name project_dir config_file)],
    ro_lazy => [qw(project_files template_format config)],
);

sub _build_project_files {
    my ($self) = @_;
    my $project_dir = $self->project_dir;

    my $out = qx{cd $project_dir && git ls-files};
    my $project_files = [ split "\n", $out ];

    return $project_files;
}

sub _build_template_format {
    my ($self) = @_;
    my $format = "package Dist::Maker::Template::@{[ $self->class_name ]};\n";
    $format .= <<'FORMAT';
use utf8;
use Mouse;
use MouseX::StrictConstructor;

use Dist::Maker::Util qw(run_command);

extends 'Dist::Maker::Base';
with    'Dist::Maker::Template';

sub dist_init {
}

sub distribution {
    # empty expression <: :> is used
    # in order to avoid to confuse PAUSE indexers
    return <<'DIST';
%s
DIST
}

no Mouse;
__PACKAGE__->meta->make_immutable();
FORMAT
}

sub _build_config {
    my ($self) = @_;
    return config_do $self->config_file;
}

sub make_template {
    my ($self) = @_;

    my $project_files = $self->project_files;
    my $dist_content = '';
    for my $filename (@$project_files) {
        $dist_content .= $self->_make_dist_content_from_file($filename);
    }

    return sprintf($self->template_format, $dist_content);
}

sub _make_dist_content_from_file {
    my ($self, $filename) = @_;
    my $config = $self->config;
    my $content = path($self->project_dir)->child($filename)->slurp;

    for my $replace_from (keys %$config) {
        my $replace_to = $config->{$replace_from};
        $filename =~ s{\Q$replace_from\E}{$replace_to}ge;
        $content =~ s{\Q$replace_from\E}{$replace_to}ge;
    }

    return sprintf("@@ %s\n%s\n", $filename, $content);
}

1;
__END__

=head1 NAME

Dist::Maker::FromProject - Perl extension to do something

=head1 VERSION

This document describes Dist::Maker::FromProject version 0.01.

=head1 SYNOPSIS

    use Dist::Maker::FromProject;

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< make_template >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

shiba_yu36 E<lt>shibayu36@gmail.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013, shiba_yu36. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
