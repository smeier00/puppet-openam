#!/usr/bin/env perl
#
# OpenAM configuration tool with more verbose error reporting than
# the configurator.jar provided in the ForgeRock installation tools.
#
# Copyright (c) 2013 Conduct AS
#

use strict;
use warnings;
use Getopt::Long;
use LWP::UserAgent;

my $config;
my %options;
GetOptions( 'file=s' => \$config ) || &usage;
( $config and -f $config ) ? configure($config) : &usage;


sub configure {
  my $config = shift;

  open(my $fh, '<', $config) || die("Unable to read from $config: $!\n");
  while(<$fh>) {
    chomp;
    my ($property, $value) = m/(.*?)=(.*)/;
    next if $_ =~ m/^\s*#/;
    next unless $property;
    $options{$property} = $value;
  }
  close($fh);

  configurator(\%options);
}

sub usage() {
  print "Usage: $0 --options\n";
  print "Options:\n";
  print "    --file, -f\n";
  print "        Specify configuration file.\n\n";
  exit 1;
}

sub configurator {
  my $options = shift;
  my $ua       = LWP::UserAgent->new;

  $options->{'ADMIN_CONFIRM_PWD'} = $options->{'ADMIN_PWD'};
  $options->{'AMLDAPUSERPASSWD_CONFIRM'}  = $options->{'AMLDAPUSERPASSWD'};

  my $configurator = $options->{'SERVER_URL'} . $options->{'DEPLOYMENT_URI'} . '/config/configurator';
  my $response = $ua->post( $configurator, $options );
  print $response->content . "\n";
}
