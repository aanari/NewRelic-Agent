# NAME

NewRelic::Agent

# VERSION

version 0.0420

# SYNOPSIS

    use NewRelic::Agent;

    my $agent = NewRelic:Agent->new(
        license_key => 'abc123',
        app_name    => 'REST API',
    );

    $agent->initialize;
    my $txn_id = $agent->begin_transaction;
    ...
    my $err_id = $agent->end_transaction($txn_id);

# DESCRIPTION

This module provides bindings for the [NewRelic](https://docs.newrelic.com/docs/agents/agent-sdk/getting-started/new-relic-agent-sdk) Agent SDK.

[![Build Status](https://travis-ci.org/aanari/NewRelic-Agent.svg?branch=master)](https://travis-ci.org/aanari/NewRelic-Agent)

# METHODS

## new

Instantiates a new NewRelic::Agent client object.

    my $agent = NewRelic::Agent->new(
        license_key          => $license_key,
        app_name             => $app_name,
        app_language         => $app_language,         #optional
        app_language_version => $app_language_version, #optional
    );

**Parameters**

- - `license_key`

    A valid NewRelic license key for your account.

    This value is also automatically sourced from the `NEWRELIC_LICENSE_KEY` environment variable.

- - `app_name`

    The name of your application.

    This value is also automatically sourced from the `NEWRELIC_APP_NAME` environment variable.

- - `app_language`

    The language that your application is written in.

    This value defaults to `perl`, and can also be automatically sourced from the `NEWRELIC_APP_LANGUAGE` environment variable.

- - `app_language_version`

    The version of the language that your application is written in.

    This value defaults to your perl version, and can also be automatically sourced from the `NEWRELIC_APP_LANGUAGE_VERSION` environment variable.

## initialize

Initialize the connection to NewRelic.

**Example:**

    $agent->initialize;

## begin\_transaction

Identifies the beginning of a transaction, which is a timed operation consisting of multiple segments. By default, transaction type is set to `WebTransaction` and transaction category is set to `Uri`.

Returns the transaction's ID on success, else negative warning code or error code.

**Example:**

    my $txn_id = $agent->begin_transaction;

## set\_transaction\_name

Sets the transaction's name.

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->set_transaction_name($txn_id, 'Create Account');

## set\_transaction\_request\_url

Sets the transaction's request url. The query part of the url is automatically stripped from the url.

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->set_transaction_request_url($txn_id, 'api.myapp.com/users/123');

## set\_transaction\_max\_trace\_segments

Sets the maximum number of trace segments allowed in a transaction trace. By default, the maximum is set to `2000`, which means the first 2000 segments in a transaction will create trace segments if the transaction exceeds the trace theshold (4 x apdex\_t).

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->set_transaction_max_trace_segments($txn_id, 5000);

## set\_transaction\_category

Sets the transaction's category name (.e.g `Uri` in "WebTransaction/Uri/<txn\_name>").

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->set_transaction_category($txn_id, 'Custom');

## set\_transaction\_type\_web

Sets the transaction type to `WebTransaction`. This will automatically change the category to `Uri`.

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->set_transaction_type_web($txn_id);

## set\_transaction\_type\_other

Sets the transaction type to `OtherTransaction`. This will automatically change the category to `Custom`.

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->set_transaction_type_other($txn_id);

## add\_transaction\_attribute

Sets a transaction attribute. Up to the first 50 attributes added are sent with each transaction.

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->add_transaction_attribute($txn_id, 'User-Agent', 'Mozilla/5.0 ...');

## notice\_transaction\_error

Identify an error that occurred during the transaction. The first identified error is sent with each transaction.

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->notice_transaction_error(
        $txn_id,
        'Runtime error',
        'Illegal division by zero',
        "Illegal division by zero at div0.pl line 4.\nmain::run() called at div0.pl line7",
        "\n",
    );

## end\_transaction

Identify the end of a transaction.

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->end_transaction($txn_id);

## record\_metric

Record a custom metric.

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->record_metric('cache_miss_timing', 0.333333);

## record\_cpu\_usage

Record CPU user time in seconds and as a percentage of CPU capacity.

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->record_cpu_usage(2.1, 0.85);

## record\_memory\_usage

Record the current amount of memory (in megabytes) being used.

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->record_memory_usage(745);

## begin\_generic\_segment

Identify the beginning of a segment that performs a generic operation. This type of segment does not create metrics, but can show up in a transaction trace if a transaction is slow enough.

Returns the segment's ID on success, else negative warning code or error code.

**Example:**

    my $seg_id = $agent->begin_generic_segment($txn_id, undef, 'Parse zip codes');

## begin\_datastore\_segment

Identify the beginning of a segment that performs a database operation. This uses the default sql\_obfuscator that strips the SQL string literals and numeric sequences, replacing them with the `?` character.

Returns the segment's ID on success, else negative warning code or error code.

**Example:**

    my $seg_id = $agent->begin_datastore_segment(
        $txn_id,
        undef,
        'users',
        'selecting user',
        'SELECT * FROM users WHERE id=?',
        'get_user_account',
    );

## begin\_external\_segment

Identify the beginning of a segment that performs an external service.

Returns the segment's ID on success, else negative warning code or error code.

**Example:**

    my $seg_id = $agent->begin_external_segment(
        $txn_id,
        undef,
        'http://api.stripe.com/v1',
        'tokenize credit card',
    );

## end\_segment

Identify the end of a segment.

Returns `0` on success, else negative warning code or error code.

**Example:**

    my $err_id = $agent->end_segment($txn_id, $seg_id);

## get\_license\_key

Returns the license key that the agent has loaded. This is useful for diagnostic purposes.

**Example:**

    my $license_key = $agent->get_license_key;

## get\_app\_name

Returns the application name that the agent has loaded. This is useful for diagnostic purposes.

**Example:**

    my $app_name = $agent->get_app_name;

## get\_app\_language

Returns the application language that the agent has loaded. This is useful for diagnostic purposes.

**Example:**

    my $app_language = $agent->get_app_language;

## get\_app\_language\_version

Returns the application language's version that the agent has loaded. This is useful for diagnostic purposes.

**Example:**

    my $app_language_version = $agent->get_app_language_version;

# BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/aanari/NewRelic-Agent/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# AUTHOR

Ali Anari <ali@anari.me>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Ali Anari.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
