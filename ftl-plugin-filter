{
    package FTL::Schema;
    use warnings;
    use strict;
    use parent "DBIx::Class::Schema";
    __PACKAGE__->load_classes("Scritto");
    1;
}

BEGIN {
    package FTL::Schema::Scritto;
    use Moose;
    extends "DBIx::Class::Core";
    with "MooseX::Object::Pluggable";

    __PACKAGE__->table("scritto");

    __PACKAGE__->add_columns(
                             "id",
                             {
                              data_type => "INT",
                              default_value => undef,
                              extra => { unsigned => 1 },
                              is_auto_increment => 1,
                              is_nullable => 0,
                              size => 10,
                             },
                             "parent",
                             {
                              data_type => "INT",
                              default_value => undef,
                              extra => { unsigned => 1 },
                              is_foreign_key => 1,
                              is_nullable => 1,
                              size => 10,
                             },
                             "scrit",
                             {
                              data_type => "MEDIUMTEXT",
                              default_value => undef,
                              is_nullable => 0,
                              size => 16777215,
                             },
                             "content_type",
                             {
                              data_type => "TEXT",
                              default_value => "text/plain",
                              is_nullable => 0,
                              size => 40,
                             },
                            );

    __PACKAGE__->set_primary_key("id");

    __PACKAGE__->belongs_to(
                            "parent",
                            "FTL::Schema::Scritto",
                            { id => "parent" },
                            { join_type => "LEFT" },
                           );

    __PACKAGE__->has_many(
                          "children",
                          "FTL::Schema::Scritto",
                          { "foreign.parent" => "self.id" },
                         );
}

{
    package FTL::Plugin::Text2HTML;
    use Moose::Role;
    sub filter {
        ( my $scrit = +shift->scrit ) =~ s/text/html/g;
        $scrit;
    }
}

my $schema = FTL::Schema->connect("dbi:SQLite:dbname=:memory:",
                                 { RaiseError => 1 });

$schema->deploy();

my $scrit_rs = $schema->resultset("Scritto");

my $scrit = $scrit_rs->create({ scrit => "Some text." });

use YAML qw( Dump );
print Dump({$scrit->get_columns});

print $scrit->scrit, $/;

$scrit->load_plugin("+FTL::Plugin::Text2HTML");

print $scrit->filter, $/;

__END__

