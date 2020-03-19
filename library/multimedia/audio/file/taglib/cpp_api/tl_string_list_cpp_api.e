note
	description: "[
		Interface to class `TagLib::StringList'
		
			#include toolkit/tstringlist.h
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-19 12:09:38 GMT (Thursday 19th March 2020)"
	revision: "3"

class
	TL_STRING_LIST_CPP_API

inherit
	EL_CPP_API

feature {NONE} -- Initialization

	frozen cpp_new: POINTER
			--
		external
			"C++ [new TagLib::StringList %"toolkit/tstringlist.h%"] ()"
		end

feature {NONE} -- Disposal

	frozen cpp_delete (self: POINTER)
			--
		external
			"C++ [delete TagLib::StringList %"toolkit/tstringlist.h%"] ()"
		end

feature {NONE} -- Measurement

	frozen cpp_size (self_ptr: POINTER): INTEGER
		--	number of elements in the list.
		external
			"C++ [TagLib::StringList %"toolkit/tstringlist.h%"] (): EIF_INTEGER"
		alias
			"size"
		end

feature {NONE} -- Element change

	frozen cpp_append (self, string: POINTER)
		-- StringList &append(const String &s);
		external
			"C++ inline use <toolkit/tstringlist.h>"
		alias
			"[
				TagLib::String &string = *((TagLib::String*)$string);
				((TagLib::StringList*)$self)->append (string)
			]"
		end

	frozen cpp_append_list (self, list: POINTER)
		-- StringList &append(const StringList &l);
		external
			"C++ inline use <toolkit/tstringlist.h>"
		alias
			"[
				TagLib::StringList &list = *((TagLib::StringList*)$list);
				((TagLib::StringList*)$self)->append (list)
			]"
		end

	frozen cpp_clear (self: POINTER)
		-- List<T> &clear();
		external
			"C++ inline use <toolkit/tstringlist.h>"
		alias
			"[
				((TagLib::StringList*)$self)->clear ()
			]"
		end

feature {NONE} -- Cursor movement

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
