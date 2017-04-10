########################################################################
# sitemap.make
#
# Define rules for sitemap.
#
# Imported variables:
#	Destination
#	Metadata
# Exported rules for:
#	$(Destination)/sitemap.*
#	all:: $(Destination)/sitemap.*

########################################################################
# Sitemap
########################################################################

define s_sitemap.jq
  $$site[0].baseurl as $$baseurl | \
  "<?xml version='\''1.0'\'' encoding='\''UTF-8'\''?> \
  <urlset xmlns:xsi='\''http://www.w3.org/2001/XMLSchema-instance'\'' \
  xsi:schemaLocation='\''http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd'\'' \
  xmlns='\''http://www.sitemaps.org/schemas/sitemap/0.9'\''>", \
  ( .pages[] |	\
    "\t<url>",	\
    "\t\t<loc>" + $$baseurl + "/" + .url + "</loc>", \
    "\t\t<lastmod>" + .updated + "</lastmod>", \
    "\t</url>"	\
  ),		\
  "</urlset>"
endef

$(Destination)/sitemap.xml: $(Metadata)/pages.json $(Metadata)/site.json \
| $(Destination)
	$(info ==> $@)
	@jq --raw-output --slurpfile site $(Metadata)/site.json '$(s_sitemap.jq)' < $< > $@

$(Destination)/sitemap.xml.gz: $(Destination)/sitemap.xml
	$(info ==> $@)
	@gzip --stdout < $< > $@

all:: $(Destination)/sitemap.xml $(Destination)/sitemap.xml.gz

# vim:ai:sw=8:ts=8:noet:fileencoding=utf8:syntax=make
