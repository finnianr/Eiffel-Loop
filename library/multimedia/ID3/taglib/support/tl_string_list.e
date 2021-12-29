note
	description: "TagLib string list `TagLib::StringList'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-26 15:46:44 GMT (Sunday 26th December 2021)"
	revision: "7"

class
	TL_STRING_LIST

inherit
	EL_OWNED_CPP_OBJECT
		export
			{EL_CPP_API} self_ptr
		end

	TL_STRING_LIST_CPP_API

	ITERABLE [ZSTRING]

	TL_SHARED_ONCE_STRING

create
	make_from_pointer, make

feature {NONE} -- Initialization

	make
		do
			make_from_pointer (cpp_new)
		end

feature -- Access

	to_list: EL_ZSTRING_LIST
		do
			create Result.make (count)
			across Current as field loop
				Result.extend (field.item)
			end
		end

feature -- Measurement

	count: INTEGER
		do
			Result := cpp_size (self_ptr)
		end

feature -- Element change

	append (list: ITERABLE [READABLE_STRING_GENERAL])
		do
			across list as str loop
				extend (str.item)
			end
		ensure
			appended: to_list.sub_list (old count + 1, count) ~ (create {like to_list}.make_from_general (list))
		end

	extend (str: READABLE_STRING_GENERAL)
		do
			Once_string.set_from_string (str)
			cpp_append (self_ptr, Once_string.self_ptr)
		ensure
			extended: to_list.last.same_string (str)
		end

	wipe_out
		do
			cpp_clear (self_ptr)
		ensure
			zero_count: count = 0
		end

feature {EL_CPP_API} -- Element change

	replace_all (list: POINTER)
		-- replace all elements with those from `list' pointer to `TagLib::StringList'
		do
			wipe_out
			cpp_append_list (self_ptr, list)
		ensure
			same_count: count = cpp_size (list)
		end

feature {NONE} -- Implementation

	new_cursor: TL_STRING_LIST_ITERATION_CURSOR
		do
			create Result.make (cpp_iterator_begin (self_ptr), cpp_iterator_end (self_ptr))
		end

end