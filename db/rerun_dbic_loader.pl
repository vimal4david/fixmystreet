#!/usr/bin/env perl

use strict;
use warnings;

BEGIN {
    use File::Basename qw(dirname);
    use File::Spec;
    my $d = dirname(File::Spec->rel2abs($0));
    require "$d/../setenv.pl";
}

# This script inspects the current state of the database and then amends the
# FixMyStreet::DB::Result::* files to suit. After running the changes should be
# inspected before the code is commited.

use FixMyStreet;
use DBIx::Class::Schema::Loader qw/ make_schema_at /;

# create a exclude statement that filters out the table that we are not
# interested in
my @tables_to_ignore = (
    'flickr_imported',     #
    'partial_user',        #
    'textmystreet',        #
);
my $exclude = '^(?:' . join( '|', @tables_to_ignore ) . ')$';

make_schema_at(
    'FixMyStreet::DB::Schema',
    {
        debug          => 0,               # switch on to be chatty
        dump_directory => './perllib',     # edit files in place
        exclude        => qr{$exclude},    # ignore some tables
        generate_pod   => 0,               # no need for pod
        overwrite_modifications => 1,      # don't worry that the md5 is wrong
        result_namespace => '+FixMyStreet::DB::Result',
        resultset_namespace => '+FixMyStreet::DB::ResultSet',

        # add in some extra components
        components => [ 'FilterColumn', 'InflateColumn::DateTime', 'EncodedColumn' ],

    },
    [ FixMyStreet->dbic_connect_info ],
);

