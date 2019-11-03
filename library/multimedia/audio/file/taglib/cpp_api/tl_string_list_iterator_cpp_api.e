note
	description: "[
		Interface to class `TagLib::StringList::ConstIterator'
		
			#include toolkit/tstringlist.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 15:53:48 GMT (Thursday 31st October 2019)"
	revision: "1"

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

	frozen cpp_item (self: POINTER): POINTER
		external
			"C++ inline use <toolkit/tstringlist.h>"
		alias
			"new TagLib::String (**((TagLib::StringList::ConstIterator*)$self))"
		end

	frozen cpp_next (self: POINTER)
		external
			"C++ inline use <toolkit/tstringlist.h>"
		alias
			"(*((TagLib::StringList::ConstIterator*)$self))++"
		end

end
