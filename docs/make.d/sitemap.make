########################################################################
# sitemap.make -- Define rules for site map.
#
# Exported rules for:
#	$(Destination)/sitemap.xml
#	$(Destination)/sitemap.xml.gz

$(Destination)/sitemap.xml: $(Metadata)/pages-by-id.json $(Metadata)/site.json make.d/sitemap.jq $(THIS) \
| $(Destination)
	$(info ==> $@)
	jq --raw-output					\
	   --slurpfile site $(Metadata)/site.json	\
	   --from-file make.d/sitemap.jq		\
	   < $< > $@

$(Destination)/sitemap.xml.gz: $(Destination)/sitemap.xml
	$(info ==> $@)
	@gzip --stdout < $< > $@

all:: $(Destination)/sitemap.xml $(Destination)/sitemap.xml.gz

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
