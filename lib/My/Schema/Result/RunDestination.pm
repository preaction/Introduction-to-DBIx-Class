package My::Schema::Result::RunDestination;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table( 'run_dest' );
__PACKAGE__->add_columns( qw( run_id dest_id ) );
__PACKAGE__->belongs_to(
    run => 'My::Schema::Result::Run' => 'run_id',
);
__PACKAGE__->belongs_to(
    destination => 'My::Schema::Result::Destination' => 'dest_id',
);
1;
