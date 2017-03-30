<#
 # Usage: <%partial analytics UA-82432866-1>
 #
 # $1: analytics UA
 #>&
<script type="text/javascript">/*<![CDATA[*/
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
  ga('create', '$1', 'auto');
  ga('send', 'pageview');
/*]]>*/</script>
<# OLD VERSION
<script type="text/javascript">
    var _gaq = _gaq || [];
    _gaq.push(["_setAccount", "$1"]);
    _gaq.push(["_trackPageview"]);
    (function() {
        var ga = document.createElement("script");
        ga.type = "text/javascript";
        ga.async = true;
        ga.src = ("https:" == document.location.protocol ? "https://ssl" : "http://www") + ".google-analytics.com/ga.js";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(ga, s);
    })();
</script>
#>&
<# LAST VERSION
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-82432866-1', 'auto');
  ga('send', 'pageview');

</script>
#>&
<#
vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=html
#>&
