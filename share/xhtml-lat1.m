<%mode comment "#" "\n">&
#  Portions (C) International Organization for Standardization 1986
#  Permission to copy in any form is granted for use with
#  conforming SGML systems and applications as defined in
#  ISO 8879, provided this notice is included in all copies.
#
<%define nbsp   \u00A0># no-break space = non-breaking space, U+00A0 ISOnum
<%define iexcl  \u00A1># inverted exclamation mark, U+00A1 ISOnum
<%define cent   \u00A2># cent sign, U+00A2 ISOnum
<%define pound  \u00A3># pound sign, U+00A3 ISOnum
<%define curren \u00A4># currency sign, U+00A4 ISOnum
<%define yen    \u00A5># yen sign = yuan sign, U+00A5 ISOnum
<%define brvbar \u00A6># broken bar = broken vertical bar, U+00A6 ISOnum
<%define sect   \u00A7># section sign, U+00A7 ISOnum
<%define uml    \u00A8># diaeresis = spacing diaeresis, U+00A8 ISOdia
<%define copy   \u00A9># copyright sign, U+00A9 ISOnum
<%define ordf   \u00AA># feminine ordinal indicator, U+00AA ISOnum
<%define laquo  \u00AB># left-pointing double angle quotation mark = left pointing guillemet, U+00AB ISOnum
<%define not    \u00AC># not sign = angled dash, U+00AC ISOnum
<%define shy    \u00AD># soft hyphen = discretionary hyphen, U+00AD ISOnum
<%define reg    \u00AE># registered sign = registered trade mark sign, U+00AE ISOnum
<%define macr   \u00AF># macron = spacing macron = overline = APL overbar, U+00AF ISOdia
<%define deg    \u00B0># degree sign, U+00B0 ISOnum
<%define plusmn \u00B1># plus-minus sign = plus-or-minus sign, U+00B1 ISOnum
<%define sup2   \u00B2># superscript two = superscript digit two = squared, U+00B2 ISOnum
<%define sup3   \u00B3># superscript three = superscript digit three = cubed, U+00B3 ISOnum
<%define acute  \u00B4># acute accent = spacing acute, U+00B4 ISOdia
<%define micro  \u00B5># micro sign, U+00B5 ISOnum
<%define para   \u00B6># pilcrow sign = paragraph sign, U+00B6 ISOnum
<%define middot \u00B7># middle dot = Georgian comma = Greek middle dot, U+00B7 ISOnum
<%define cedil  \u00B8># cedilla = spacing cedilla, U+00B8 ISOdia
<%define sup1   \u00B9># superscript one = superscript digit one, U+00B9 ISOnum
<%define ordm   \u00BA># masculine ordinal indicator, U+00BA ISOnum
<%define raquo  \u00BB># right-pointing double angle quotation mark = right pointing guillemet, U+00BB ISOnum
<%define frac14 \u00BC># vulgar fraction one quarter = fraction one quarter, U+00BC ISOnum
<%define frac12 \u00BD># vulgar fraction one half = fraction one half, U+00BD ISOnum
<%define frac34 \u00BE># vulgar fraction three quarters = fraction three quarters, U+00BE ISOnum
<%define iquest \u00BF># inverted question mark = turned question mark, U+00BF ISOnum
<%define Agrave \u00C0># latin capital letter A with grave = latin capital letter A grave, U+00C0 ISOlat1
<%define Aacute \u00C1># latin capital letter A with acute, U+00C1 ISOlat1
<%define Acirc  \u00C2># latin capital letter A with circumflex, U+00C2 ISOlat1
<%define Atilde \u00C3># latin capital letter A with tilde, U+00C3 ISOlat1
<%define Auml   \u00C4># latin capital letter A with diaeresis, U+00C4 ISOlat1
<%define Aring  \u00C5># latin capital letter A with ring above = latin capital letter A ring, U+00C5 ISOlat1
<%define AElig  \u00C6># latin capital letter AE = latin capital ligature AE, U+00C6 ISOlat1
<%define Ccedil \u00C7># latin capital letter C with cedilla, U+00C7 ISOlat1
<%define Egrave \u00C8># latin capital letter E with grave, U+00C8 ISOlat1
<%define Eacute \u00C9># latin capital letter E with acute, U+00C9 ISOlat1
<%define Ecirc  \u00CA># latin capital letter E with circumflex, U+00CA ISOlat1
<%define Euml   \u00CB># latin capital letter E with diaeresis, U+00CB ISOlat1
<%define Igrave \u00CC># latin capital letter I with grave, U+00CC ISOlat1
<%define Iacute \u00CD># latin capital letter I with acute, U+00CD ISOlat1
<%define Icirc  \u00CE># latin capital letter I with circumflex, U+00CE ISOlat1
<%define Iuml   \u00CF># latin capital letter I with diaeresis, U+00CF ISOlat1
<%define ETH    \u00D0># latin capital letter ETH, U+00D0 ISOlat1
<%define Ntilde \u00D1># latin capital letter N with tilde, U+00D1 ISOlat1
<%define Ograve \u00D2># latin capital letter O with grave, U+00D2 ISOlat1
<%define Oacute \u00D3># latin capital letter O with acute, U+00D3 ISOlat1
<%define Ocirc  \u00D4># latin capital letter O with circumflex, U+00D4 ISOlat1
<%define Otilde \u00D5># latin capital letter O with tilde, U+00D5 ISOlat1
<%define Ouml   \u00D6># latin capital letter O with diaeresis, U+00D6 ISOlat1
<%define times  \u00D7># multiplication sign, U+00D7 ISOnum
<%define Oslash \u00D8># latin capital letter O with stroke = latin capital letter O slash, U+00D8 ISOlat1
<%define Ugrave \u00D9># latin capital letter U with grave, U+00D9 ISOlat1
<%define Uacute \u00DA># latin capital letter U with acute, U+00DA ISOlat1
<%define Ucirc  \u00DB># latin capital letter U with circumflex, U+00DB ISOlat1
<%define Uuml   \u00DC># latin capital letter U with diaeresis, U+00DC ISOlat1
<%define Yacute \u00DD># latin capital letter Y with acute, U+00DD ISOlat1
<%define THORN  \u00DE># latin capital letter THORN, U+00DE ISOlat1
<%define szlig  \u00DF># latin small letter sharp s = ess-zed, U+00DF ISOlat1
<%define agrave \u00E0># latin small letter a with grave = latin small letter a grave, U+00E0 ISOlat1
<%define aacute \u00E1># latin small letter a with acute, U+00E1 ISOlat1
<%define acirc  \u00E2># latin small letter a with circumflex, U+00E2 ISOlat1
<%define atilde \u00E3># latin small letter a with tilde, U+00E3 ISOlat1
<%define auml   \u00E4># latin small letter a with diaeresis, U+00E4 ISOlat1
<%define aring  \u00E5># latin small letter a with ring above = latin small letter a ring, U+00E5 ISOlat1
<%define aelig  \u00E6># latin small letter ae = latin small ligature ae, U+00E6 ISOlat1
<%define ccedil \u00E7># latin small letter c with cedilla, U+00E7 ISOlat1
<%define egrave \u00E8># latin small letter e with grave, U+00E8 ISOlat1
<%define eacute \u00E9># latin small letter e with acute, U+00E9 ISOlat1
<%define ecirc  \u00EA># latin small letter e with circumflex, U+00EA ISOlat1
<%define euml   \u00EB># latin small letter e with diaeresis, U+00EB ISOlat1
<%define igrave \u00EC># latin small letter i with grave, U+00EC ISOlat1
<%define iacute \u00ED># latin small letter i with acute, U+00ED ISOlat1
<%define icirc  \u00EE># latin small letter i with circumflex, U+00EE ISOlat1
<%define iuml   \u00EF># latin small letter i with diaeresis, U+00EF ISOlat1
<%define eth    \u00F0># latin small letter eth, U+00F0 ISOlat1
<%define ntilde \u00F1># latin small letter n with tilde, U+00F1 ISOlat1
<%define ograve \u00F2># latin small letter o with grave, U+00F2 ISOlat1
<%define oacute \u00F3># latin small letter o with acute, U+00F3 ISOlat1
<%define ocirc  \u00F4># latin small letter o with circumflex, U+00F4 ISOlat1
<%define otilde \u00F5># latin small letter o with tilde, U+00F5 ISOlat1
<%define ouml   \u00F6># latin small letter o with diaeresis, U+00F6 ISOlat1
<%define divide \u00F7># division sign, U+00F7 ISOnum
<%define oslash \u00F8># latin small letter o with stroke, = latin small letter o slash, U+00F8 ISOlat1
<%define ugrave \u00F9># latin small letter u with grave, U+00F9 ISOlat1
<%define uacute \u00FA># latin small letter u with acute, U+00FA ISOlat1
<%define ucirc  \u00FB># latin small letter u with circumflex, U+00FB ISOlat1
<%define uuml   \u00FC># latin small letter u with diaeresis, U+00FC ISOlat1
<%define yacute \u00FD># latin small letter y with acute, U+00FD ISOlat1
<%define thorn  \u00FE># latin small letter thorn, U+00FE ISOlat1
<%define yuml   \u00FF># latin small letter y with diaeresis, U+00FF ISOlat1
# vim:syntax=perl
