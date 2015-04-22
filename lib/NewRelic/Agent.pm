package NewRelic::Agent;
use strict;
use warnings;
use Method::Signatures;

our $VERSION = '0.02';

require XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

method new(%args) {
    my $license_key          = delete $args{license_key}
                            || $ENV{NEWRELIC_LICENSE_KEY}
                            || '';
    my $app_name             = delete $args{app_name}
                            || $ENV{NEWRELIC_APP_NAME}
                            || 'AppName';
    my $app_language         = delete $args{app_language}
                            || $ENV{NEWRELIC_APP_LANGUAGE}
                            || 'perl';
    my $app_language_version = delete $args{app_language_version}
                            || $ENV{NEWRELIC_APP_LANGUAGE_VERSION}
                            || $];

    $self->_new($license_key, $app_name, $app_language, $app_language_version);
}

1;
