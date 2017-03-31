////////////////////////////////////////////////////////////////////////
// BEM macros
////////////////////////////////////////////////////////////////////////

// Simple selector
//
// Prefix selector with the escape character \ if necessary. Do not change
// selectors if they start with [A-Za-z_-].
//
&define{SEL}{.&if{$1 =~ [A-Za-z_-]*}$1&else\$1&endif}

// Block, element, modifier
//
// Cases:
//
// &BEM{block}                      => .block
// &BEM{block}{}{modifier}          => .block_modifier
// &BEM{block}{element}             => .block__element
// &BEM{block}{element}{modifier}   => .block__element_modifier
//
&define{BEM}{&SEL{$1}&ifneq{$2}{}__$2&endif&ifneq{$3}{}_$3&endif}

// Chained modifier
//
// Cases:
//
// &CHM{block}{modifier}            => .block.-modifier
// &CHM{block}{element}{modifier}   => .block__element.-modifier
//
&define{CHM}{&SEL{$1}&ifneq{$2}{}__$2&endif.-$3}

// Hack
// 
// Prefix selector with underline character and protect name with the escape
// character \ if necessary.
// 
// ._N
//
&define{HACK}{._&if{$1 =~ [A-Za-z_-]*}$1&else\$1&endif}

// Naming conventions:
//  component, block, module    &BEM &CHM
//  #object, #layout            &BEM &CHM
//  %utility                    &SEL
//  $scope                      &SEL
//  ^theme                      &SEL
//  _hack                       &HACK

// vim:ts=4:sw=4:ai:et:fileencoding=utf8:syntax=cpp
