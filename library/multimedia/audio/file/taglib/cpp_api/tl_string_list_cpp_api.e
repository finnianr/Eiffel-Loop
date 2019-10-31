note
	description: "Interface to class `TagLib::StringList' defined in `toolkit/tstringlist.h'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 15:06:06 GMT (Thursday   31st   October   2019)"
	revision: "1"

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

	frozen cpp_field_list_begin (self: POINTER): POINTER
		external
			"C++ inline use <toolkit/tstringlist.h>"
		alias
			"new TagLib::StringList::ConstIterator (((TagLib::StringList*)$self)->begin())"
		end

	frozen cpp_field_list_end (self: POINTER): POINTER
		external
			"C++ inline use <toolkit/tstringlist.h>"
		alias
			"new TagLib::StringList::ConstIterator (((TagLib::StringList*)$self)->end())"
		end
end
