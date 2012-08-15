#!/usr/bin/env perl
#|-------------+---------------------------------------------------------------|
#| Title       | mozbookmarks2urls.pl                                          |
#|-------------+---------------------------------------------------------------|
#| Date        | 2012-06-28                                                    |
#|-------------+---------------------------------------------------------------|
#| Author      | Israel Fimbres D. <israel.fimbres@gmail.com>                  |
#|-------------+---------------------------------------------------------------|
#| Version     | 1.0                                                           |
#|-------------+---------------------------------------------------------------|
#| Description | Gets the uris stored inside a mozilla bookmark database.      |
#|             | If a file isn't provided as a parameter it processes the most |
#|             | recent bookmark file inside                                   |
#|             | $HOME/.mozilla/firefox/*.default/bookmarkbackups/ instead     |
#|-------------+---------------------------------------------------------------|
#| Usage       | mozbookmarks2urls.pl bookmarks-2012-06-19.json                |
#|-------------+---------------------------------------------------------------|

use strict;

use JSON::XS;

my ($file_name, $json) = @ARGV ? shift @ARGV : (
 map { $_->[0] }
 sort { $a->[1] <=> $b->[1] }
 map { [$_, (stat)[9]] }
 <$ENV{HOME}/.mozilla/firefox/*.default/bookmarkbackups/*>
)[-1] or die "Couldn't get the bookmark database file.";

{
  open my $fh, '<', $file_name or die $!;
  $json = decode_json join '', <$fh>;
  close $fh;
}

sub traverse {
  my $node = shift;

  $node->{uri} =~ /^http/ and print $node->{uri}, "\n" if exists $node->{uri};

  if (exists $node->{children}) {
    traverse($_) for (@{$node->{children}});
  }
}

traverse $json;

exit 0;
