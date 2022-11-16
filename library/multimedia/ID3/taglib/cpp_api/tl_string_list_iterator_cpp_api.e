note
	description: "[
		Interface to class `TagLib::StringList::ConstIterator'
		
			#include toolkit/tstringlist.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	TL_STRING_LIST_ITERATOR_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Externals

	frozen cpp_after (iterator, it_end: POINTER): BOOLEAN
		external
			"C++ inline use <toolkit/tstringlist.h>"
		alias
			"[
				TagLib::StringList::ConstIterator&
					iterator = *(TagLib::StringList::ConstIterator*)$iterator,
					end = *(TagLib::StringList::ConstIterator*)$it_end;
				return iterator == end
			]"
		end

	frozen cpp_delete (self: POINTER)
			--
		external
			"C++ [delete TagLib::StringList::ConstIterator %"toolkit/tstringlist.h%"] ()"
		end

	frozen cpp_get_item (self, text_out: POINTER)
		external
			"C++ inline use <toolkit/tstringlist.h>"
		alias
			"[
				TagLib::String &text = *((TagLib::String*)$text_out);
				text.clear().append(**((TagLib::StringList::ConstIterator*)$self))
			]"
		end

	frozen cpp_next (self: POINTER)
		external
			"C++ inline use <toolkit/tstringlist.h>"
		alias
			"(*((TagLib::StringList::ConstIterator*)$self))++"
		end

end