package ShinyCMS::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';


=head1 NAME

ShinyCMS::Model::DB

=head1 SYNOPSIS

See L<ShinyCMS>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<ShinyCMS::Schema>

=head1 AUTHOR

Denny de la Haye <2019@denny.me>

=head1 COPYRIGHT

Copyright (c) 2009-2019 Denny de la Haye.

=head1 LICENSING

ShinyCMS is free software; you can redistribute it and/or modify it under the
terms of either:

a) the GNU General Public License as published by the Free Software Foundation;
   either version 2, or (at your option) any later version, or

b) the "Artistic License"; either version 2, or (at your option) any later
   version.

https://www.gnu.org/licenses/gpl-2.0.en.html
https://opensource.org/licenses/Artistic-2.0

=cut

__PACKAGE__->meta->make_immutable;

1;
