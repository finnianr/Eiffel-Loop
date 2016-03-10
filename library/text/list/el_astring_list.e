note
	description: "Summary description for {EL_ASTRING_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "4"

class
	EL_ASTRING_LIST

inherit
	EL_STRING_LIST [ASTRING]
		redefine
			proper_cased
		end

create
	make, make_empty, make_with_separator, make_with_lines, make_with_words, make_from_array

convert
	make_from_array ({ARRAY [ASTRING]}), make_with_words ({ASTRING})

feature {NONE} -- Implementation

	proper_cased (word: like item): like item
		do
			Result := word.as_proper_case
		end

end
