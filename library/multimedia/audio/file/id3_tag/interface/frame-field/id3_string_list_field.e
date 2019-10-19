note
	description: "Summary description for {ID3_STRING_LIST_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
