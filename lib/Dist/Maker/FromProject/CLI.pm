package Dist::Maker::FromProject::CLI;
use strict;
use warnings;

use Getopt::Long;
use Dist::Maker::FromProject;

sub new {
    my $class = shift;
    bless { }, $class;
}

sub run {
    my ($self, @args) = @_;

    local @ARGV = @args;
    my $p = Getopt::Long::Parser->new(
        config => ["no_ignore_case", "pass_through"],
    );
    $p->getoptions(
        "help=s"        => \$self->{help},
        "class=s"       => \$self->{class},
        "config-file=s" => \$self->{config_file},
        "project-dir=s" => \$self->{project_dir},
    );

    # --help option
    if ($self->{help}) {
        $self->usage;
        return;
    }

    unless ($self->{class} && $self->{project_dir}) {
        $self->usage;
        return;
    }

    my $dim_from_project = Dist::Maker::FromProject->new({
        class_name  => $self->{class},
        project_dir => $self->{project_dir},
        config_file => $self->{config_file},
    });
    my $template = $dim_from_project->make_template;

    $self->print($template);
}

sub usage {
    my $self = shift;
    my $msg = <<"HELP";
Usage: dim-from-project --class=WebApp --config-file=<path> --project-dir=<path> [--help]
HELP
    $self->print($msg);
}

sub print {
    my ($self, $msg) = @_;
    print STDOUT $msg;
}

1;
