note
	description: "Date-time object makeable from canonical ISO-8601 formatted string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-12 10:17:54 GMT (Wednesday 12th May 2021)"
	revision: "10"

class
	EL_ISO_8601_DATE_TIME

inherit
	EL_DATE_TIME
		redefine
			make, Default_format_string, to_string
		end

create
	make, make_now, make_from_other

feature -- Initialization

	make (s: STRING)
		require else
			valid_format: is_valid_format (s)
		local
			modified: STRING
		do
			modified := buffer_8.copied_substring (s, 1, T_index - 1)
			append_space (modified)
			modified.append_substring (s, T_index + 1, Input_string_count - 1)
			Precursor (modified)
		ensure then
			reversible: s ~ to_string
		end

feature -- Conversion

	to_string: STRING
		-- format as "yyyy[0]mm[0]Tdd[0]hh[0]mi[0]ssZ"
		do
			create Result.make (Input_string_count)
			Result.append (formatted_out (Default_format_string))
			place_time_delimiter (Result)
			Result.append_character ('Z')
		ensure then
			-- Ignoring fine seconds
			reversible: relative_duration (create {like Current}.make (Result)).seconds_count = 0
		end

feature -- Contract Support

	is_valid_format (s: STRING): BOOLEAN
		do
			if s.count = Input_string_count then
				Result := s [T_index] = 'T' and s [Input_string_count] = 'Z'
			end
		end

feature {NONE} -- Implementation

	append_space (modified: STRING)
		do
			modified.append_character (' ')
		end

	place_time_delimiter (string: STRING)
		do
			string [T_index] := 'T'
		end

feature -- Constant

	Default_format_string: STRING
			-- Default output format string
		once
			Result := "yyyy-[0]mm-[0]dd [0]hh:[0]mi:[0]ss"
		end

feature {NONE} -- Constant

	Input_string_count: INTEGER
		once
			Result := 20
		end

	T_index: INTEGER
		once
			Result := 11
		end

end