<# examples from GPM paper #>&
<%define A A$1A>&
<%define B B<%A X$1X>B>&
<%define APA P$1$1P>&
&
<%A C>
<%A ACA>
<%A <%A C>>
<%A XDX>
<%B D>
<%A P>
<%APA Y>
<%call <%A P> Y>
&
<%mode comment qqq "[" "]">&
Q[<%A C>]R
<%A [<%A X>]>
<%B [<%A X>]>
Q[<%]R[>]
Q[[<%A C>]]R
&
<# Output:
	ACA
	AACAA
	AACAA
	AXDXA
	BAXDXAB
	APA
	PYYP
	PYYP
	Q<%A C>R
	A<%A X>A
	BAX<%A X>XAB
	Q<%R>
	Q[<%A C>]R
#>&
