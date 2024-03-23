syn match ptFirst '^[A-Za-zÀ-û]\+' contained display 
syn match ptFirst '\(\. \)\@<=[A-Za-zÀ-û]\+' contained display
syn match ptLast '[A-Za-zÀ-û]\+\([\.$]\)\@=' contained display
syn match ptPunct '[^A-Za-zÀ-û ]' contained display
syn match ptNumbers '[0-9]' contained display

" match \w+ if there's 5 sequences of group of characters separated by space
" before it
syn match ptRepeatConstant '\([^ ]\+ \)\{5}\zs\w\+'  contained display
" match \w+ if before it there's 2 groups of characters with length between 1,4 and have
" spaces separating them
syn match ptRepeatRelative '\(\(\s\)\@<=\S\{1,4}\(\s\)\@= \)\{2}\zs\w\+' contained display

syn region ptSentences start="\. \|^" end="\.\|$" contains=CONTAINED

hi def link ptPunct Statement
hi def link ptFirst Function
hi def link ptLast Constant
hi def link ptRepeatConstant Type
hi def link ptRepeatRelative Comment
hi def link ptNumbers Statement

"only first match
"^.\{-}\(teste\)
"ãáàâéêíóõôúçãÁÀÂÉÊÍÓÕÔÚÇ
