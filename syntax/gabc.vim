if exists('b:current_syntax')
  finish
endif

syntax case match

syntax match gabcComment /%.*/
syntax match gabcHeaderKey /^\s*\w\+\ze\s*:/
syntax match gabcHeaderSeparator /^%%\+\s*$/
syntax match gabcParens /[()]/
syntax match gabcBrackets /[\[\]]/
syntax match gabcClef /\v<(c|cb|f)[1-4]>/
syntax match gabcPitch /\v[A-Ma-mnp]/
syntax match gabcBar /\v(::|:|;|,|`|')/

highlight default link gabcComment Comment
highlight default link gabcHeaderKey Keyword
highlight default link gabcHeaderSeparator PreProc
highlight default link gabcParens Delimiter
highlight default link gabcBrackets Delimiter
highlight default link gabcClef Type
highlight default link gabcPitch Constant
highlight default link gabcBar Operator

let b:current_syntax = 'gabc'
