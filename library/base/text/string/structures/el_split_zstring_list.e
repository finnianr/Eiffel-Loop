note
	description: "[
		List of [$source EL_ZSTRING] split parts delimited by `delimiter'
		
		This is a more efficient way to process split strings as it doesn't create a new string
		instance for each split part.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-14 12:05:40 GMT (Monday 14th August 2017)"
	revision: "1"

class
	EL_SPLIT_ZSTRING_LIST

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			do_all as do_all_intervals,
			for_all as for_all_intervals,
			make as make_intervals,
			item as interval_item,
			item_lower as start_index,
			item_upper as end_index,
			there_exists as there_exists_interval
		end

create
	make

feature {NONE} -- Initialization

	make (a_string: like string; delimiter: READABLE_STRING_GENERAL)
		do
			string := a_string
			area_v2 := string.split_intervals (delimiter).area
			create internal_item.make_empty
		end

feature -- Access

	item: ZSTRING
		-- split item
		do
			Result := internal_item
			Result.wipe_out
			Result.append_substring (string, start_index, end_index)
		end

feature -- Basic operations

	append_item_to (str: ZSTRING)
		do
			str.append_substring (string, start_index, end_index)
		end

	do_all (action: PROCEDURE [ZSTRING])
		-- apply `action' for all delimited substrings
		do
			action.set_operands (Tuple)
			from start until after loop
				Tuple.substring := item
				action.apply
				forth
			end
		end

feature -- Status query

	for_all (predicate: PREDICATE [ZSTRING]): BOOLEAN
		-- `True' if all split items match `predicate'
		do
			Result := True
			predicate.set_operands (Tuple)
			from start until not Result or after loop
				Tuple.substring := item; predicate.apply
				Result := predicate.last_result
				forth
			end
		end

	there_exists (predicate: PREDICATE [ZSTRING]): BOOLEAN
		-- `True' if one split substring matches `predicate'
		do
			predicate.set_operands (Tuple)
			from start until Result or after loop
				Tuple.substring := item; predicate.apply
				Result := predicate.last_result
				forth
			end
		end

feature {NONE} -- Internal attributes

	internal_item: ZSTRING

	string: ZSTRING

feature {NONE} -- Constants

	Tuple: TUPLE [substring: ZSTRING]
		once
			create Result
		end
end
