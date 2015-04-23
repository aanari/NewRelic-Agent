package Plack::Middleware::NewRelic;
use parent qw(Plack::Middleware);
use Method::Signatures;
use NewRelic::Agent;
use Plack::Request;
use Plack::Util;
use Plack::Util::Accessor qw(agent enabled license_key app_name);

# ABSTRACT: Plack middleware for NewRelic APM instrumentation

method prepare_app {
    return unless $self->enabled && $self->license_key && $self->app_name;
    $self->agent(
        NewRelic::Agent->new(
            license_key => $self->license_key,
            app_name    => $self->app_name,
        )
    );
}

method call($env) {
    $txn_id;
    if ($self->agent) {
        $txn_id = $self->agent->begin_transaction;
        my $req = Plack::Request->new($env);
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

    my $res = $self->app->($env);
 
    if (ref($res) and 'ARRAY' eq ref($res)) {
        $self->agent->end_transaction($txn_id) if $txn_id;
        return $res;
    }
 
    Plack::Util::response_cb(
        $res,
        func($res) {
            func($chunk) {
                if (!defined $chunk) {
                    $self->agent->end_transaction($txn_id) if $txn_id;
                    return;
                }
                return $chunk;
            }
        }
    );
}

1;
