package My::Schema::Result::Job;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table( 'jobs' );
__PACKAGE__->add_columns( qw( id type name ) );
__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->has_many(
    runs => 'My::Schema::Result::Run' => 'job_id',
);

sub latest_run {
    my ( $self ) = @_;

    my $latest_run_rs = $self->runs->search(
        { },
        {
            order_by => { -desc => 'start' },
            limit => 1,
        },
    );

    return $latest_run_rs->next;
}

1;
