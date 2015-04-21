use Test::Most;
use Data::Dump;
BEGIN { use_ok('NewRelic::Agent') };

my $o = NewRelic::Agent->new;
dd $o->GetInt();

done_testing;
