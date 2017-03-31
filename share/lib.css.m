//
// CSS macros
//
// Included in CSS expansion
//
&mode{push}&
&mode{string}{ccc "&\n" "" ""}&
&mode{string}{ccc "<#" "#>" ""}&
&mode{string}{iqi "'" "'" ""}&
&mode{string}{iQi "\"" "\"" ""}&
&mode{user}{"<%" ">" "\B" "\B" "\W>" "<" ">" "$" ""}&
&mode{meta}{"<%" ">" "\B" "\B" "\W>" "<" ">"}&
<%include "lib-common.m">&
<%mode pop>&
//
// Usage: &A&_{}B
//
// Null macro
//
&define{_}{$1}&
// vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=perl
