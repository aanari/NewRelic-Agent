# NAME

Plack::Middleware::NewRelic - Plack middleware for NewRelic APM instrumentation

# VERSION

version 0.02

# SYNOPSIS

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

# DESCRIPTION

With the above in place, [Plack::Middleware::NewRelic](https://metacpan.org/pod/Plack::Middleware::NewRelic) will instrument your
Plack application and send information to NewRelic, using the [NewRelic::Agent](https://metacpan.org/pod/NewRelic::Agent)
module. All configuration options are required for this middleware to function.

[![Build Status](https://travis-ci.org/aanari/Plack-Middleware-NewRelic.svg?branch=master)](https://travis-ci.org/aanari/Plack-Middleware-NewRelic)

# BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/aanari/Plack-Middleware-NewRelic/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# AUTHOR

Ali Anari <ali@anari.me>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Ali Anari.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
