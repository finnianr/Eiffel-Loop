note
	description: "Variable table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "6"

deferred class
	EL_VARIABLE_TABLE [G]

inherit
	HASH_TABLE [G, STRING]

feature {NONE} -- Initialization

	make_from_file (file_path: FILE_PATH)
			--
		local
			file_in: PLAIN_TEXT_FILE; variable: STRING
		do
			make (7)
			from
				create file_in.make_open_read (file_path)
				file_in.read_word
			until
				file_in.last_string.count = 0
			loop
				variable := file_in.last_string.out
				file_in.read_word
				put (value_from_string (file_in.last_string), variable)
				file_in.read_word
			end
			file_in.close
		end


feature -- Status query

	has_variable_with_value (variable: STRING; value: G): BOOLEAN
			--
		require
			has_variable: has (variable)
		do
			if value = item (variable) then
				Result := true
			else
				variable_not_found (variable, value)
			end
		end

feature {NONE} -- Implementation

	value_from_string (string: STRING): G
			--
		deferred
		end

	variable_not_found (variable: STRING; value: G)
			--
		deferred
		end

end
