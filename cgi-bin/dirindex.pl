#!/usr/bin/perl
use strict;

use URI::Escape;

use constant HTTP_HEADER => "Content-type: text/html\n\n";
use constant HTML_HEADER => <<"EOF";
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>index of $ENV{'REQUEST_URI'}</title>
    <link rel="stylesheet" href="/.index.css">
  </head>
  <body>
    <div class="files">
EOF
use constant HTML_FOOTER => <<EOF;
    </div>
  </body>
</html>
EOF

my $dir = uri_unescape("$ENV{'REQUEST_URI'}");
my $fileroot = uri_unescape("$ENV{'CONTEXT_DOCUMENT_ROOT'}");

my @unsorted_files;
opendir (DIR, $fileroot . $dir) or die "couldn't open directory $!";
while (my $f = readdir DIR) {
  push @unsorted_files, $f
}
closedir DIR;
my @files = sort @unsorted_files; # sort flenames

print HTTP_HEADER;
print HTML_HEADER;
print '<p><a href=".." class="parent-folder">^ parent folder</a><p>';
print '<p><a href="as-zip" class="zip-link">download folder as zip</a></p>';
foreach (@files) {
  my $f = $fileroot . $dir . $_;
  if (m/^[^\.]/) {
    if (-f $f) {
      print "<p><a href=\"$_\" class=\"file-link\">$_</a></p>\n";
    } elsif (-d $f) {
      print "<p><a href=\"$_\" class=\"dir-link\">$_</a></p>\n";
    }
  }
  if (m/\.(jpe?g|png)/) {
    if (-f $f) {
      print "<style>body { background: #051107 url(\"$dir/$_\") no-repeat center fixed; background-size: contain; }</style>";
    }
  }
}
print HTML_FOOTER;
