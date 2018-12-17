note
	description: "String interval"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_STRING_INTERVAL

feature -- Access

	count: INTEGER

	offset: INTEGER -- Zero based index

feature -- Element Change

	set_interval (a_interval: like interval)
		do
			count := a_interval.to_integer_32
			offset := (a_interval |>> 32).to_integer_32
		end

	set_offset_and_count (a_offset, a_count: INTEGER)
			--
		do
			offset := a_offset; count := a_count
		end

	set_count (a_count: INTEGER)
			--
		do
			count := a_count
		end

	set_from_other (a_interval: EL_STRING_INTERVAL)
		do
			count := a_interval.count
			offset := a_interval.offset
		end

feature {NONE} -- Internal attributes

	interval: INTEGER_64
		do
			Result := (offset.to_integer_64 |<< 32) | count
		end

end