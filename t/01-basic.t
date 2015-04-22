use strict;
use warnings;

use Test::More;
BEGIN { use_ok('NewRelic::Agent') };

SCOPE: {
  my $o = NewRelic::Agent->new;
  check_obj($o);

  is($o->GetInt(), 0);
  is($o->GetString(), "");

  $o->SetInt(3);
  is($o->GetInt(), 3);
  $o->SetString("fOo");
  is($o->GetString(), "fOo");
}


sub check_obj {
  my $o = shift;
  isa_ok($o, 'NewRelic::Agent');
  can_ok($o, $_) foreach qw(new SetString SetInt GetInt GetString Sum);
  ok(!$o->can($_)) foreach qw(SetValue);
}

done_testing;
