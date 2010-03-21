# Demystifycpp  


## Overview


Demystifycpp resurrects functionality that used to work out of the box for 
Emacs C mode: preprocssor macro expansion. 

The problem of macro expansion has resurfaced in modern C++ due to limitations
with meta-programming in C++. Although frowned uopon in general use because of
issues inherent to macro hygene and type safety, pre-processor macros
are seeing a resurgance in their popularity in C++ meta programming where 
they are used to compensate for the inherent limitations of template parameterization 
(STL) as a meta programming tool. Pre-processor macros allow arbitraty textual
transformations, hence may be used, in a very limited way, to similar effect as Lisp macros.

Pre-processor expansion is provided natively by C++ compilers, yet listing header
includes usually yields multiple thousands of lines of output for even
the tiniest C++ code examples --- which makes sensible code navigation nearly impossible.
Demystifycpp solves this by truncating includes and presenting a read only buffer
with all macros expanded directly in the editor. 

Copyright (C) 2010 Christoph A. Kohlhepp, all rights reserved.
Email chrisk at manx dot net

Licensed under the GNU General Public License.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.


