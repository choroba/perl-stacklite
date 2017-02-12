SHELL := /bin/bash

plot3d = 'set term png; set dgrid3d; set view $(1), $(2) ; splot "$(3)" with pm3d title "perl $(4) per year"'

default: perl-yh.png perl-yw.png

questions.sorted: questions.csv
	time LC_ALL=C sort -u -t, -k1,1 $< > $@

perl_tags.csv: question_tags.csv
	time grep 'perl\b\|perl5' $< > $@

perl_tags.sorted: perl_tags.csv
	time LC_ALL=C sort -u -t, -k1,1 $< > $@

perl_q.csv: perl_tags.sorted questions.sorted
	time join -t, -j1 perl_tags.sorted questions.sorted > $@

perl_qw.csv : perl_q.csv
	time add-weekday.pl $< > $@

perl-yw: perl-yh
perl-yh: perl_qw.csv
	time relative.pl $<

perl-yh.png: perl-yh
	gnuplot <<< $(call plot3d,66,74,perl-yh,hour) > $@

perl-yw.png: perl-yw
	gnuplot <<< $(call plot3d,72,71,perl-yw,weekday) > $@

clean:
	rm -f questions.sorted perl_tags.csv perl_tags.sorted \
	    perl_q.csv perl_qw.csv perl-y[hw] perl-y[hw].png

.PHONY: default clean
