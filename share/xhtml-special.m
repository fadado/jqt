<%mode comment "#" "\n">&
#  Special characters for XHTML
#
#  Portions (C) International Organization for Standardization 1986:
#  Permission to copy in any form is granted for use with
#  conforming SGML systems and applications as defined in
#  ISO 8879, provided this notice is included in all copies.
#
#  Relevant ISO entity set is given unless names are newly introduced.
#  New names (i.e., not in ISO 8879 list) do not clash with any
#  existing ISO 8879 entity names. ISO 10646 character numbers
#  are given for each character, in hex. values are decimal
#  conversions of the ISO 10646 values and refer to the document
#  character set. Names are Unicode names.
#
# C0 Controls and Basic Latin
<%define quot    \u0022>#  quotation mark, U+0022 ISOnum
<%define amp     \u0026>#  ampersand, U+0026 ISOnum
<%define lt      \u003C>#  less-than sign, U+003C ISOnum
<%define gt      \u003E>#  greater-than sign, U+003E ISOnum
<%define apos	\u0027>#  apostrophe = APL quote, U+0027 ISOnum
# Latin Extended-A
<%define OElig   \u0152>#  latin capital ligature OE, U+0152 ISOlat2
<%define oelig   \u0153>#  latin small ligature oe, U+0153 ISOlat2
# ligature is a misnomer, this is a separate character in some languages
<%define Scaron  \u0160>#  latin capital letter S with caron, U+0160 ISOlat2
<%define scaron  \u0161>#  latin small letter s with caron, U+0161 ISOlat2
<%define Yuml    \u0178>#  latin capital letter Y with diaeresis, U+0178 ISOlat2
# Spacing Modifier Letters
<%define circ    \u02C6>#  modifier letter circumflex accent, U+02C6 ISOpub
<%define tilde   \u02DC>#  small tilde, U+02DC ISOdia
# General Punctuation
<%define ensp    \u2002># en space, U+2002 ISOpub
<%define emsp    \u2003># em space, U+2003 ISOpub
<%define thinsp  \u2009># thin space, U+2009 ISOpub
<%define zwnj    \u200C># zero width non-joiner, U+200C NEW RFC 2070
<%define zwj     \u200D># zero width joiner, U+200D NEW RFC 2070
<%define lrm     \u200E># left-to-right mark, U+200E NEW RFC 2070
<%define rlm     \u200F># right-to-left mark, U+200F NEW RFC 2070
<%define ndash   \u2013># en dash, U+2013 ISOpub
<%define mdash   \u2014># em dash, U+2014 ISOpub
<%define lsquo   \u2018># left single quotation mark, U+2018 ISOnum
<%define rsquo   \u2019># right single quotation mark, U+2019 ISOnum
<%define sbquo   \u201A># single low-9 quotation mark, U+201A NEW
<%define ldquo   \u201C># left double quotation mark, U+201C ISOnum
<%define rdquo   \u201D># right double quotation mark, U+201D ISOnum
<%define bdquo   \u201E># double low-9 quotation mark, U+201E NEW
<%define dagger  \u2020># dagger, U+2020 ISOpub
<%define Dagger  \u2021># double dagger, U+2021 ISOpub
<%define permil  \u2030># per mille sign, U+2030 ISOtech
<%define lsaquo  \u2039># single left-pointing angle quotation mark, U+2039 ISO proposed
# lsaquo is proposed but not yet ISO standardized
<%define rsaquo  \u203A># single right-pointing angle quotation mark, U+203A ISO proposed
# rsaquo is proposed but not yet ISO standardized
# Currency Symbols
<%define euro   \u20AC>#  euro sign, U+20AC NEW
# vim:syntax=none
