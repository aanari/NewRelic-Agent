package NewRelic::Agent;

use 5.008008;
use strict;
use warnings;

use XSLoader ();
require Exporter;

our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [qw(
)]);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '0.001';
XSLoader::load __PACKAGE__, $VERSION;

1;
