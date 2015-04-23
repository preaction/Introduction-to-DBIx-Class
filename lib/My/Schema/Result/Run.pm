package My::Schema::Result::Run;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table( 'runs' );
__PACKAGE__->add_columns( qw( id job_id start end status ) );
__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->belongs_to(
    job => 'My::Schema::Result::Job' => 'job_id',
);
__PACKAGE__->has_many(
    run_dest => 'My::Schema::Result::RunDestination' => 'run_id',
);
__PACKAGE__->many_to_many(
    destinations => 'My::Schema::Result::RunDestination' => 'destination',
);
1;
