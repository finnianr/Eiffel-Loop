note
	description: "Id3 string list field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-17 11:39:33 GMT (Thursday   17th   October   2019)"
	revision: "1"

deferred class
	ID3_STRING_LIST_FIELD

inherit
	ID3_ENCODEABLE_FRAME_FIELD

feature -- Access

	i_th_string (index: INTEGER): ZSTRING
		require
			valid_index: valid_index (index)
		deferred
		end

	list: EL_ZSTRING_LIST
			--
		do
			from create Result.make (count) until Result.full loop
				Result.extend (i_th_string (Result.count + 1))
			end
		end

	type: NATURAL_8
		do
			Result := Field_type.string_list
		end

	count: INTEGER
		deferred
		end

	first: ZSTRING
		require
			at_least_one: not is_empty
		deferred
		end

feature -- Status query

	valid_index (index: INTEGER): BOOLEAN
		do
			Result := 1 <= index and index <= count
		end

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

feature -- Element change

	set_list (a_list: ITERABLE [ZSTRING])
			--
		deferred
		ensure
			is_set: list.same_items (a_list)
		end

end
