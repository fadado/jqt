########################################################################
# sitemap.jq -- Generate site map XML file.
#
# jq -r -f sitemap.jq
#   --slurpfile site $(Metadata)/site.json
#   < $(Metadata)/pages-by-id.json 
#   > $(Destination)/sitemap.xml

$site[0].baseurl as $baseurl |

"<?xml version='1.0' encoding='UTF-8'?>",

"<urlset xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd' xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>",

(.[] |
    "\t<url>",
    "\t\t<loc>" + $baseurl + "/" + .url + "</loc>",
    "\t\t<lastmod>" + .updated + "</lastmod>",
    "\t</url>"
),

"</urlset>"

# vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=jq
