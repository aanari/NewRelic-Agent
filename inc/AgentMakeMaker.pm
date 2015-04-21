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

    my @LIBS = glob File::Spec->catdir($sdk, 'lib', '*');

    return +{
        %{ super() },
        depend => { 'WithAgent.c' => 'NewRelic-Agent.xsp' },
        CC     => $CC,
        INC    => join(' ', map { "-I$_" } @INC),
        LD     => '$(CC)',
        LIBS   => join(' ', map { "-l$_" } @LIBS),
        OBJECT => '$(O_FILES)',
        XSOPT  => '-C++ -hiertype',
    };
};

__PACKAGE__->meta->make_immutable;
