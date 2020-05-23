#!/usr/bin/env perl

use strict;
use warnings;

use Fcntl qw(:flock);
use HTTP::Tiny;
use File::Temp ();
use File::Copy qw(move);

# Assure that there isn't another instance of ourselves already in progress.
# Lock this script's source file, which prevents it being used more than once at a time.
open my $guardian_fh, '<', $0 or die $!;
flock $guardian_fh, LOCK_EX | LOCK_NB
    or die "There can only be one: $!\n";

our $SCHEMA     = 'https';
our $API        = 'source.unsplash.com';
#our $END_POINT  = 'random';
our $END_POINT  = '1920x1080';
our $QUERY      = 'nature,water';

my $url         = $SCHEMA . '://' . $API . '/' . $END_POINT . ($QUERY ? "?$QUERY" : '');

#our $API = 'https://api.unisplash.com';

my $http = HTTP::Tiny->new(
    timeout     => 5,
    max_size    => 10*1024*1024, # 10 MB ought to be sufficient.
);

my $resp = $http->get($url);
die "Failed to fetch photo: status: $resp->{'status'}, msg: $resp->{'reason'}\n"
    unless $resp->{'status'} eq '200';

my $content = $resp->{'content'};

die "Content was empty.\n" unless defined $content && length $content;
my $content_type = $resp->{'headers'}->{'content-type'};
my $file_ext = $content_type =~ m{^image/(.+)$} ? $1 : die "Invalid content-type: $content_type\n";
my $output_path = "/var/tmp/bgimage.$file_ext";

# Obtain a temporary file to save the contents into.
my $tfile = File::Temp->new(
    TEMPLATE    => 'bgimage-XXXXXX',
    SUFFIX      => ".$file_ext",
    TMPDIR      => 1,
);

print $tfile $content;

$tfile->flush;

move($tfile->filename, $output_path)
    || die 'Failed to move ' . $tfile->filename . " to $output_path: $!\n";

$tfile->close;

my @cmd = ('/usr/bin/gsettings', 'set', 'org.gnome.desktop.background', 'picture-uri', "file://$output_path");
if ($ENV{'DRYRUN'}) {
    print @cmd, "\n";
}
else {
    system(@cmd);
}

print "Background changed at ", time(), "\n";

