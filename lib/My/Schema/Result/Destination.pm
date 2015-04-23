package My::Schema::Result::Destination;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table( 'dest' );
__PACKAGE__->add_columns( qw( id type name ) );
__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->has_many(
    run_dest => 'My::Schema::Result::RunDestination' => 'dest_id',
);
__PACKAGE__->many_to_many(
    runs => 'My::Schema::Result::RunDestination' => 'run',
);
1;
