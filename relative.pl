#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

my %total;

while (<>) {
    chomp;
    my ($datetime, $wday) = (split /,/)[ 2, -1 ];
    my ($year, $hour) = (split /[-T:]/, $datetime)[ 0, 3 ];

    $total{all}++;
    $total{year}{$year}++;
    $total{hour}{$hour}++;
    $total{wday}{$wday}++;
    $total{yw}{$year}{$wday}++;
    $total{yh}{$year}{$hour}++;

}

my @years = keys %{ $total{year} };
my @hours = keys %{ $total{hour} };
my @wdays = keys %{ $total{wday} };

my %relative;
for my $year (@years) {
    $relative{year}{$year} = $total{year}{$year} / $total{all};
    for my $hour (@hours) {
        $relative{hour}{$hour} //= $total{hour}{$hour} / $total{all};
        $relative{yh}{$year}{$hour} = $total{yh}{$year}{$hour} / $total{year}{$year};
        $relative{hy}{$hour}{$year} = $total{yh}{$year}{$hour} / $total{hour}{$hour};
    }
    for my $wday (@wdays) {
        $relative{wday}{$wday} //= $total{wday}{$wday} / $total{all};
        $relative{yw}{$year}{$wday} = $total{yw}{$year}{$wday} / $total{year}{$year};
        $relative{wy}{$wday}{$year} = $total{yw}{$year}{$wday} / $total{wday}{$wday};
    }
}

open my $YW, '>', 'perl-yw' or die $!;
open my $YH, '>', 'perl-yh' or die $!;

for my $year (@years) {
    for my $wday (@wdays) {
        say {$YW} "$year $wday $relative{yw}{$year}{$wday}";
    }
    for my $hour (@hours) {
        say {$YH} "$year $hour $relative{yh}{$year}{$hour}";
    }
}
