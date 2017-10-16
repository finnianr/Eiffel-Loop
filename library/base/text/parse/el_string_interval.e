note
	description: "Summary description for {EL_STRING_INTERVAL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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