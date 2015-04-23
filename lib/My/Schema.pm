package My::Schema;
use base qw/DBIx::Class::Schema/;
# Load My::Schema::Result::* and My::Schema::Resultset::*
__PACKAGE__->load_namespaces;
1;
