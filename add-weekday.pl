#!/usr/bin/perl
use warnings;
use strict;

use Time::Piece;

while (<>) {
    chomp;
    my @fields = split /,/, $_, 4;
    my $tp = 'Time::Piece'->strptime($fields[2], '%Y-%m-%dT%H:%M:%SZ');
    push @fields, $tp->day_of_week;
    {   local $" = ',';
        print "@fields\n";
    }
}
