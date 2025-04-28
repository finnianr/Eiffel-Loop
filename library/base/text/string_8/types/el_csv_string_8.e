note
	description: "Comma separated value string with UTF-8 or Latin-1 encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 14:30:31 GMT (Monday 28th April 2025)"
	revision: "2"

class
	EL_CSV_STRING_8

inherit
	STRING
		rename
			extend as extend_character
		export
			{NONE} all
			{ANY} count, is_empty, wipe_out
		end

create
	make, make_empty

feature -- Element change

	extend (value: READABLE_STRING_8)
		do
			if count > 0 then
				append_character (',')
			end
			append (value)
		end

feature -- Conversion

	to_immutable_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		-- split list of `IMMUTABLE_STRING_8' strings, each with shared `area' from `Current'
		do
			create Result.make_shared (substring (1, count), ',')
		end
end