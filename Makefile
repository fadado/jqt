all:
	cp -v /tmp/jqt/* .

pub:
	git push origin gh-pages
