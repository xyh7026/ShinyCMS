# ===================================================================
# File:		t/admin-controllers/controller_Admin-FileServer.t
# Project:	ShinyCMS
# Purpose:	Tests for fileserver admin features
# 
# Author:	Denny de la Haye <2019@denny.me>
# Copyright (c) 2009-2019 Denny de la Haye
# 
# ShinyCMS is free software; you can redistribute it and/or modify it
# under the terms of either the GPL 2.0 or the Artistic License 2.0
# ===================================================================

use strict;
use warnings;

use Test::More;

use lib 't/support';
require 'login_helpers.pl';  ## no critic

create_test_admin();

my $t = login_test_admin() or die 'Failed to log in as admin';

$t->get_ok(
    '/admin',
    'Fetch admin area'
);
# Get a list of all files which have access log data
$t->follow_link_ok(
    { text => 'Fileserver logs' },
    'Follow link to view access logs for all files'
);
$t->title_is(
	'Access logs for all files - ShinyCMS',
	'Reached list of files'
);
# Look at second page of data, to make Devel::Cover happy
$t->get_ok(
    $t->uri->path . '?page=2',
    'Fetch second page of data'
);
$t->back;
# View access logs for specific file
$t->follow_link_ok(
    { text => 'Access Logs' },
    'Follow link to view access logs for first file listed'
);
$t->title_is(
	'Access logs for: catalyst_logo.png - ShinyCMS',
	'Reached access logs for specific file'
);
$t->text_contains(
	'10.20.30.40',
	'Found expected IP address'
);
# Look at second page of data, to make Devel::Cover happy
$t->get_ok(
    $t->uri->path . '?page=2',
    'Fetch second page of data'
);
$t->back;
# Get list of files in specified path which have access data
$t->get_ok(
    '/admin/fileserver/access-logs/testdir',
    "Fetch list of restricted files in 'testdir' directory"
);
$t->title_is(
	'Access logs for: testdir - ShinyCMS',
	'Reached list of files in specific directory'
);
# Look at second page of data, to make Devel::Cover happy
$t->get_ok(
    $t->uri->path . '?page=2',
    'Fetch second page of data'
);
remove_test_admin();

# Now try again with no relevant privs and make sure we're shut out
create_test_admin( 'CMS Page Editor' );
$t = login_test_admin();
$t->get_ok(
    '/admin/fileserver/access-logs',
    'Attempt to fetch fileserver admin area as CMS Page Editor'
);
$t->title_unlike(
	qr/Access logs/,
	'Failed to reach fileserver access logs without any appropriate roles enabled'
);
remove_test_admin();

done_testing();
