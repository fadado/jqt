########################################################################
# sitemap.make -- Define rules for site map.
#
# Exported rules for:
#	$(Root)/sitemap.xml
#	$(Root)/sitemap.xml.gz

$(Root)/sitemap.xml: $(SCRIPT) $(THIS)
$(Root)/sitemap.xml: $(Meta)/pages-by-id.json $(Meta)/phase1_site.json \
| $(Root)
	$(info ==> $@)
	jq --raw-output					\
	   --slurpfile site $(Meta)/phase1_site.json	\
	   --from-file $(MDIR)/sitemap.jq		\
	   < $< > $@

$(Root)/sitemap.xml.gz: $(Root)/sitemap.xml
	$(info ==> $@)
	@gzip --stdout < $< > $@

build:: $(Root)/sitemap.xml $(Root)/sitemap.xml.gz

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
