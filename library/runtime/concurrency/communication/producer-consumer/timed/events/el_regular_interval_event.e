note
	description: "Regular interval event"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_REGULAR_INTERVAL_EVENT

inherit
	EL_REGULAR_INTERVAL_EVENT_CONSTANTS
		redefine
			out
		end

create
	make, make_delimiter_start, make_delimiter_end

feature {NONE} -- Initialization

	make (millisecs, a_count: INTEGER)
			--
		do
			elapsed_millisecs := millisecs
			count := a_count
		end

	make_delimiter_start
			--
		do
			type := Delimiter_start
		end

	make_delimiter_end
			--
		do
			type := Delimiter_end
		end

feature -- Access

	elapsed_millisecs: INTEGER

	count: INTEGER

	type: INTEGER
		--

	out: STRING
			--
		do
			Result := out_string
			Result.wipe_out
			Result.append ("Event: [")
			inspect type
				when Delimiter_start then
					Result.append ("START")

				when Delimiter_end then
					Result.append ("END")

			else
				Result.append_integer (count)
				Result.append (", ")
				Result.append_integer (elapsed_millisecs)
			end
			Result.append_character (']')
		end

feature {NONE} -- Implementation

	out_string: STRING
			--
		once
			create Result.make (24)
		end

end