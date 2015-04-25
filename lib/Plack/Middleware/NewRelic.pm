package Plack::Middleware::NewRelic;
use parent qw(Plack::Middleware);
use Method::Signatures;
use NewRelic::Agent;
use Plack::Request;
use Plack::Util;
use Plack::Util::Accessor qw(agent license_key app_name);

# ABSTRACT: Plack middleware for NewRelic APM instrumentation

method prepare_app {
    my $license_key = $self->license_key || $ENV{NEWRELIC_LICENSE_KEY};
    my $app_name    = $self->app_name    || $ENV{NEWRELIC_APP_NAME};

    die 'Missing NewRelic license key' unless $license_key;
    die 'Missing NewRelic app name'    unless $app_name;

    $self->agent(
        NewRelic::Agent->new(
            license_key => $license_key,
            app_name    => $app_name,
        )
    );
    $self->agent->initialize;
}

method call(HashRef $env) {
    $self->begin_transaction($env)
        if $self->agent;

    my $res = $self->app->($env);
 
    if (ref($res) and 'ARRAY' eq ref($res)) {
        $self->end_transaction($env);
        return $res;
    }
 
    Plack::Util::response_cb(
        $res,
        func($res) {
            func($chunk) {
                if (!defined $chunk) {
                    $self->end_transaction($env);
                    return;
                }
                return $chunk;
            }
        }
    );
}

method begin_transaction(HashRef $env) {
    # Begin the transaction
    my $txn_id = $self->agent->begin_transaction;
    return unless $txn_id >= 0;
    my $req = Plack::Request->new($env);
    $env->{TRANSACTION_ID} = $txn_id;

    # Populate transaction data
    $self->agent->set_transaction_request_url($txn_id, $req->request_uri);
    my $method = $req->method;
    my $path   = $req->path;
    $self->agent->set_transaction_name($txn_id, "$method $path");
    for my $key (qw/Accept Accept-Language User-Agent/) {
        my $value = $req->header($key);
        $self->agent->add_transaction_attribute($txn_id, $key, $value)
            if $value;
    }
}

method end_transaction(HashRef $env) {
    if (my $txn_id = $env->{TRANSACTION_ID}) {
        $self->agent->end_transaction($txn_id);
    }
}

1;

=head1 SYNOPSIS

    use Plack::Builder;
    use Plack::Middleware::NewRelic;
    my $app = sub { ... } # as usual
    # NewRelic Options
    my %options = (
        enabled     => 1,
        license_key => 'asdf1234',
        app_name    => 'REST API',
    );
    builder {
        enable "Plack::Middleware::NewRelic", %options;
        $app;
    };

=head1 DESCRIPTION

With the above in place, L<Plack::Middleware::NewRelic> will instrument your
Plack application and send information to NewRelic, using the L<NewRelic::Agent>
module.

=for markdown [![Build Status](https://travis-ci.org/aanari/Plack-Middleware-NewRelic.svg?branch=master)](https://travis-ci.org/aanari/Plack-Middleware-NewRelic)

B<Parameters>

=over 4

=item - C<license_key>

A valid NewRelic license key for your account.

This value is also automatically sourced from the C<NEWRELIC_LICENSE_KEY> environment variable.

=item - C<app_name>

The name of your application.

This value is also automatically sourced from the C<NEWRELIC_APP_NAME> environment variable.

=back

=cut
