package ShinyCMS::Schema::Result::Forum;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn");

=head1 NAME

ShinyCMS::Schema::Result::Forum

=cut

__PACKAGE__->table("forum");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 section

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 url_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 display_order

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "section",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "url_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "display_order",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 section

Type: belongs_to

Related object: L<ShinyCMS::Schema::Result::ForumSection>

=cut

__PACKAGE__->belongs_to(
  "section",
  "ShinyCMS::Schema::Result::ForumSection",
  { id => "section" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 forum_posts

Type: has_many

Related object: L<ShinyCMS::Schema::Result::ForumPost>

=cut

__PACKAGE__->has_many(
  "forum_posts",
  "ShinyCMS::Schema::Result::ForumPost",
  { "foreign.forum" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07006 @ 2011-04-15 19:00:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HfeJxGOb8R/CYMNfqokdww


=head2 post_count

Return total count of top-level posts in this forum.

=cut

sub post_count {
	my( $self ) = @_;
	return $self->forum_posts->count;
}


=head2 comment_count

Return total count of comments in this forum.

=cut

sub comment_count {
	my( $self ) = @_;
	
	my @posts = $self->forum_posts;
	
	my $count = 0;
	foreach my $post ( @posts ) {
		next unless $post->discussion and $post->discussion->comments;
		$count += $post->discussion->comments->count;
	}
	
	return $count;
}


=head2 sorted_posts

Return associated posts in specified display order.

=cut

sub sorted_posts {
	my( $self ) = @_;
	return $self->forum_posts->search(
		{},
		{ order_by => 'display_order' },
	);
}


=head2 most_recent_comment

Returns details of the most recent comment on a post in this forum

=cut

sub most_recent_comment {
	my( $self ) = @_;
	
	my @posts = $self->forum_posts;
	
	my $most_recent_comment;
	my $most_recent_post;
	foreach my $post ( @posts ) {
		my $comment = $post->most_recent_comment;
		$most_recent_comment = $comment unless $most_recent_comment;
		$most_recent_post    = $post    unless $most_recent_post;
		if ( $comment and $comment->posted > $most_recent_comment->posted ) {
			$most_recent_comment = $comment;
			$most_recent_post    = $post;
		}
	}
	my $mrc = {};
	$mrc->{ comment } = $most_recent_comment;
	$mrc->{ post    } = $most_recent_post;
	return $mrc;
}


# EOF
__PACKAGE__->meta->make_immutable;
1;

