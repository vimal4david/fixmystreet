package FixMyStreet::App::Controller::Admin::ReportExtraFields;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }


sub begin : Private {
    my ( $self, $c ) = @_;

    $c->forward('/admin/begin');
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    my @extras = $c->model('DB::ReportExtraFields')->search(
        undef,
        {
            order_by => 'name'
        }
    );

    $c->stash->{extra_fields} = \@extras;
}

sub edit : Path : Args(1) {
    my ( $self, $c, $extra_id ) = @_;

    my $extra;
    if ( $extra_id eq 'new' ) {
        $extra = $c->model('DB::ReportExtraFields')->new({});
    } else {
        $extra = $c->model('DB::ReportExtraFields')->find( $extra_id )
            or $c->detach( '/page_error_404_not_found' );
    }

    if ($c->req->method eq 'POST') {
        $c->forward('/auth/check_csrf_token');

        foreach (qw/name cobrand language/) {
            $extra->$_($c->get_param($_));
        }
        $c->forward('/admin/update_extra_fields', [ $extra ]);

        $extra->update_or_insert;
    }

    $c->forward('/auth/get_csrf_token');

    $c->stash->{extra} = $extra;
}

__PACKAGE__->meta->make_immutable;

1;
