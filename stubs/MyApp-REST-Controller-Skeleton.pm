package MyApp::Controller::Skeleton;
use Moose;
# use Moose::Util::TypeConstraints;
use namespace::autoclean;
BEGIN { extends "Catalyst::Controller::REST" }
no warnings "uninitialized";

sub base :Chained("/") :PathPart("api/skeleton") :CaptureArgs(0) {
#    my ( $self, $c ) = @_;
}

sub list :Chained("base") :PathPart("") :Args(0) :ActionClass("REST") {}

sub list_GET :Private {
    my ( $self, $c ) = @_;
    # Paging.
}

sub list_POST :Private {
    my ( $self, $c ) = @_;
    # Both need location–
    # status_accepted for long term processing.
    # status_created for known return URIs.
        $entity->{viewer} = $viewer->as_string if $viewer;
}

# No, PUT is edit.
# *list_PUT = *list_POST;

sub base_with_id :Chained("base") :PathPart("") :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    # load item.
}

sub id :Chained("base_with_id") :PathPart("") :Args(0) :ActionClass("REST") {}

sub id_GET :Private {
    my ( $self, $c ) = @_;
    # $self->status_ok( $c, entity => \%info );
}

sub id_PUT {
    my ( $self, $c ) = @_;
#    return $self->status_bad_request( $c, message => "safjlasf" )
}

sub id_DELETE {
    my ( $self, $c ) = @_;
    #$self->status_accepted($c, { entity => { status => "Deleted",
    #                                             skeleton => {} );
}

#sub end :Private {
#    my ( $self, $c ) = @_;
#    $c->forward("/api/end");
#}

__PACKAGE__->meta->make_immutable;

__END__
