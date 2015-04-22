package inc::AgentMakeMaker;
use Moose;
extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

use File::Spec;

override _build_WriteMakefile_args => sub {
    my ($self) = @_;

    my $curdir = File::Spec->curdir;
    my $sdk    = File::Spec->catdir($curdir, 'sdk');

    my $CC  = 'g++';
    my @INC = (
        $curdir,
        File::Spec->catdir($sdk, 'include'),
    );

    my @LIBS = map {
        '-L' . File::Spec->catdir($sdk, 'lib') . "-l$_"
    } qw/newrelic-common newrelic-collector-client newrelic-transaction/;

    return +{
        %{ super() },
        depend        => { 'WithAgent.c' => 'NewRelic-Agent.xsp' },
        CC            => $CC,
        INC           => join(' ', map { "-I$_" } @INC),
        LD            => '$(CC)',
        LIBS          => \@LIBS,
        OBJECT        => '$(O_FILES)',
        XSOPT         => '-C++ -hiertype',
    };
};

__PACKAGE__->meta->make_immutable;
