note
	description: "A vector of boolean values using C++ type `std::vector<bool>'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-31 12:51:20 GMT (Wednesday 31st March 2021)"
	revision: "1"

class
	EL_CPP_BOOLEAN_VECTOR

inherit
	EL_OWNED_CPP_OBJECT

	READABLE_INDEXABLE [BOOLEAN]

create
	make_filled

feature {NONE} -- Initialization

	make_filled (n: INTEGER; value: BOOLEAN)
		do
			make_from_pointer (cpp_new (n, value))
		end

feature -- Access

	item alias "[]", at alias "@" (i: INTEGER): BOOLEAN assign put
		do
			Result := cpp_at (self_ptr, i)
		end

feature -- Measurement

	count: INTEGER
		do
			Result := cpp_size (self_ptr)
		end

	lower: INTEGER = 0

	upper: INTEGER
		do
			Result := count - 1
		end

feature -- Status query

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := lower <= i and i <= upper
		end

feature -- Element change

	put (v: BOOLEAN; i: INTEGER)
		do
			cpp_put (self_ptr, v, i)
		ensure
			set: v = item (i)
		end

feature {NONE} -- Disposal

	frozen cpp_delete (self: POINTER)
		external
			"C++ [delete std::vector<bool> <vector>] ()"
		end

feature {NONE} -- Implementation

	frozen cpp_put (self: POINTER; value: BOOLEAN; index: INTEGER)
		external
			"C++ inline use <vector>"
		alias
			"[
				std::vector<bool> &array = *((std::vector<bool>*)$self);
				array [(std::size_t)$index] = (bool)$value
			]"
		end

	frozen cpp_at (self: POINTER; index: INTEGER): BOOLEAN
		external
			"C++ inline use <vector>"
		alias
			"[
				std::vector<bool> &array = *((std::vector<bool>*)$self);
				return (EIF_BOOLEAN) array [(std::size_t)$index]
			]"
		end

	frozen cpp_new (size: INTEGER; value: BOOLEAN): POINTER
		external
			"C++ inline use <vector>"
		alias
			"[
				bool v = (bool)$value;
				return new std::vector<bool> ((std::size_t)$size, v)
			]"
		end

	frozen cpp_size (self: POINTER): INTEGER
		external
			"C++ [std::vector<bool> <vector>] (): EIF_INTEGER"
		alias
			"size"
		end

end