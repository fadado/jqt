////////////////////////////////////////////////////////////////////////
// BEM macros
////////////////////////////////////////////////////////////////////////

// Selector, escaped if necessary
// .s .\s
&define{SEL}{.&if{$1 =~ [A-Za-z_-]*}$1&else\$1&endif}

// Block, element, modifier
// .B, .B--M, .B__E, .B__E--M
&define{BEM}{&SEL{$1}&ifneq{$2}{}__$2&endif&ifneq{$3}{}--$3&endif}

// Chained modifier
// .B.-M, .B__E.-M
&define{CHAIN}{&SEL{$1}&ifneq{$2}{}__$2&endif.-$3}

// Hack
// ._N
&define{HACK}{._&if{$1 =~ [A-Za-z_-]*}$1&else\$1&endif}

// Naming conventions:
//  component, block, module    &BEM &CHAIN
//  #object, #layout            &BEM &CHAIN
//  %utility                    &SEL
//  $scope                      &SEL
//  ^theme                      &SEL
//  _hack                       &HACK

// ???
//  ?is (state)                 &SEL
//  !has (state)                &SEL

// vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=cpp
