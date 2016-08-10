<#
 # Example user defined macros
 #>
<#
 # <%sc word>
 # <%sc 'text with spaces'>
 #>
<%define sc <span style="font-variant:small-caps;">$1</span>>&
<#
 # <%cite word>
 # <%cite 'text with spaces'>
 #>
<%define cite <cite>$1</cite>>&
<#
 # <%vimeo 38514156 560 315>
 #>
<%define vimeo
    <iframe src="http://player.vimeo.com/video/$1" width="$2" height="$3" frameborder="0"></iframe>
>&
<#
 # <%slideshare FOuwiWHTdrs1OJ 595 485>
 #>
<%define slideshare 
    <iframe src="//www.slideshare.net/slideshow/embed_code/key/$1"
            width="$2"
            height="$3"
            frameborder="0"
            marginwidth="0"
            marginheight="0"
            scrolling="no">
    </iframe>
>&
<#
 # vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=perl
 #>
