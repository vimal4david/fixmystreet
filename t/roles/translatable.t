use FixMyStreet::TestMech;
my $mech = FixMyStreet::TestMech->new;

my $body = FixMyStreet::DB->resultset("Body")->create({ name => 'Dunkirk' });
my $contact = $mech->create_contact_ok(
    body => $body,
    email => 'potholes@dunkirk',
    category => 'Potholes'
);

FixMyStreet::DB->resultset("Translation")->create({
    lang => "fr",
    tbl => "body",
    object_id => $body->id,
    col => "name",
    msgstr => "Dunkerque",
});

FixMyStreet::DB->resultset("Translation")->create({
    lang => "de",
    tbl => "contact",
    object_id => $contact->id,
    col => "category",
    msgstr => "Schlaglöcher",
});

FixMyStreet::DB->resultset("Translation")->create({
    lang => "nb",
    tbl => "contact",
    object_id => $contact->id,
    col => "category",
    msgstr => "Hull i veien",
});

my ($problem) = $mech->create_problems_for_body(1, $body->id, "Title", {
    whensent => \'current_timestamp',
    category => 'Potholes',
});

is $body->name, "Dunkirk";
is $contact->category_display, "Potholes";
is $problem->category_display, "Potholes";

FixMyStreet::DB->schema->lang("fr");
is $body->name, "Dunkerque";
is $contact->category_display, "Potholes";
is $problem->category_display, "Potholes";

FixMyStreet::DB->schema->lang("de");
is $body->name, "Dunkirk";
is $contact->category_display, "Schlaglöcher";
is $problem->category_display, "Schlaglöcher";

FixMyStreet::override_config {
    ALLOWED_COBRANDS => [ 'fiksgatami' ],
}, sub {
    $mech->get_ok($problem->url);
	$mech->content_contains('Hull i veien');

    # XXX TODO Any displayed problem category needs to use category_display
    # Most use same in option value and display e.g. list filter etc.
};

done_testing;
