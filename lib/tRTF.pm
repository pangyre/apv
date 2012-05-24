package tRTF;
use Mouse;
with "nodeRole";
use Mouse::Util::TypeConstraints;
use strictures;
no warnings "uninitialized";
use open qw(:std :utf8);
use RTF::Tokenizer;

enum "tRTFname" => qw( rtf group control text eof );

has "type" =>
    is => "rw",
    isa => "tRTFname",
    required => 1,
    ;

has "argument" =>
    is => "ro",
    isa => "Str",
    predicate => "has_argument",    
    ;

has "parameter" =>
    is => "ro",
    isa => "Str",
    # lazy_build => 1,
    ;

has "control" =>
    is => "ro",
    isa => "Str",
    init_arg => undef,
    writer => "_control",
    ;

sub BUILD {
    my $self = shift;
    die "argument is required"
        if $self->parent and not $self->has_argument;
    $self->_control($self->argument) if $self->type eq "control";
}

sub text_content {
    my $self = shift;
    my $text = "";
    $text = $self->argument if $self->is_text;

#            and $self->parent->first_child->argument eq "rtlch";
#            and $self->parent->first_child->argument ne "*";

    for my $kid ( $self->children )
    {
        #$text .= $kid->parent->argument . " : ";
        $text .= $kid->text_content;
        #$text .= "\n";
    }
    $text;
}

my %TEXT = map {; $_ => 1 }
   qw( rtf pard plain );

sub is_text {
    my $self = shift;
    return unless $self->type eq "text";
    # print join(" + ", map { $_->control } $self->siblings), $/;
    return if $self->argument =~ /(?<!\\);\z/;
    my @siblings = $self->siblings;
    return if @siblings > 1 and $self->parent->first_child->control eq "*";
    return 1 if grep { $TEXT{$_->control} } $self->siblings;
#        return 1 if grep { $TEXT{$_->control} } $self->parent->previous ? $self->parent->previous->children : ();
    return;
}
#

#    sub add_text { +shift->{text} .= join "", @_ }

sub parse {
    my $self = shift;
    $self->reset;

    unshift @_, (-e $_[0]) ? "file" : "string" if @_ == 1;
    my $tokenizer = RTF::Tokenizer->new( $_[0] => "$_[1]" );

    my $node;
    while ( my ( $type, $arg, $param ) = $tokenizer->get_token() )
    {
        $node ||= $self;

        if ( $type eq "group" and $arg == 0 )
        {
            $node = $node->parent;
            next;
        }

        my $kid = tRTF->new( type => $type,
                             argument => $arg,
                             parameter => $param );

        $node->add_child($kid);

        last if $type eq "eof";
    }
    $self;
}

__PACKAGE__->meta->make_immutable;

BEGIN {
    package nodeRole;
    use Mouse::Role;
    no warnings "uninitialized";

    has "kids" =>
        traits  => ["Array"],
        is => "rw",
        isa => "ArrayRef",
        default => sub { [] },
        handles => {
            _add_child      => "push",
            children        => "elements",
            get_child       => "get",
            size            => "count",
            filter_children => "grep",
#            map_options    => "map",
#            find_option    => "first",
#            join_options   => "join",
#            has_no_options => "is_empty",
#            sorted_options => "sort",
        },
    ;

    sub first_child {
        +shift->get_child(0);
    }

    sub reset { +shift->kids([]) }

    sub add_child {
        my $self = shift;
        my $child = shift || confess "No child given";
        # more validation blessed($child) ...
        # Track index or anything like that?
        $self->_add_child($child);
        $child->_position($self->size);
        $child->_set_parent($self);
    }

    has "parent" =>
        is => "ro",
        isa => "Any",
        writer => "_set_parent",
        weak_ref  => 1,
        ;

    has "position" =>
        is => "ro",
        isa => "Any",
        writer => "_position",
        ;

    sub ancestors {
        my $self = shift;
        my @lineage = ( $self->parent );
        while ( $lineage[0] and $lineage[0]->parent )
        {
            unshift @lineage, $lineage[0]->parent;
        }
        @lineage;
    }

    sub root {
        die "Find top node without parent";
    }

    sub siblings {
        my $self = shift;
        my $parent = $self->parent;;
        return () if $parent->size <= 1;
        my $skip = $self->position - 1;
        my @indices = grep { $_ != $skip } ( 0 .. ( $parent->size - 1 ));
        @{ $parent->kids }[@indices]; # 321 tweak!
    }

    sub previous {
        my $self = shift;
        return unless $self->position > 1;
        $self->parent->get_child($self->position - 2); # with off-by-one.
    }

    sub next {
        my $self = shift;
        return unless $self->position < $self->parent->size;
        $self->parent->get_child($self->position); # with off-by-one.
    }

    sub serialize {
        my $self = shift;
        my $indent = shift || 0;
        my $serialization = shift || "";

        $serialization .= # sprintf "%s%s\n", "   " x $indent, $self->type;
            sprintf qq{%s |%-7s "%s" + "%s"\n},
            ("   " x $indent), $self->type, substr($self->argument,0,90), $self->parameter;
        
        $indent++;
        for my $kid ( $self->children )
        {
            $serialization .= $kid->serialize($indent);
        }
        $indent--;

        $serialization;
    }

}

1;

__DATA__

    Very decent guide: http://www.biblioscape.com/rtf15_spec.htm
  https://metacpan.org/module/The_RTF_Cookbook
