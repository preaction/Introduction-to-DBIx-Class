package My::Schema::Result::Job;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table( 'jobs' );
__PACKAGE__->add_columns( qw( id type name ) );
__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->has_many(
    runs => 'My::Schema::Result::Run' => 'job_id',
);
1;
