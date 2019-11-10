note
	description: "[
		Interface to class `TagLib::StringList'
		
			#include toolkit/tstringlist.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-10 19:40:29 GMT (Sunday 10th November 2019)"
	revision: "2"

class
	TL_STRING_LIST_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- C++ Externals

	frozen cpp_delete (self: POINTER)
			--
		external
			"C++ [delete TagLib::StringList %"toolkit/tstringlist.h%"] ()"
		end

	frozen cpp_size (self_ptr: POINTER): INTEGER
		--	Returns the size of the string.
		-- unsigned int size() const;
		external
			"C++ [TagLib::StringList %"toolkit/tstringlist.h%"] (): EIF_INTEGER"
		alias
			"size"
		end

	frozen cpp_iterator_begin (self: POINTER): POINTER
		external
			"C++ inline use <toolkit/tstringlist.h>"
		alias
			"new TagLib::StringList::ConstIterator (((TagLib::StringList*)$self)->begin())"
		end

	frozen cpp_iterator_end (self: POINTER): POINTER
		external
			"C++ inline use <toolkit/tstringlist.h>"
		alias
			"new TagLib::StringList::ConstIterator (((TagLib::StringList*)$self)->end())"
		end
end
