note
	description: "App just for fun to decode messages from Marta"
	notes: "Commented for beginner level coders"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 6:06:07 GMT (Monday 7th February 2022)"
	revision: "6"

class
	BINARY_DECODE_APP

inherit
	EL_APPLICATION

	EL_MODULE_ARGS; EL_MODULE_FILE

feature {NONE} -- Initialization

	initialize
		local
			file_path: FILE_PATH; string_8: EL_STRING_8_ROUTINES
		do
			file_path := Args.file_path (option_name)
			-- Get location of file
			if file_path.exists then
				-- Assign the text of the file to a STRING if the file exists
				file_text := File.plain_text (file_path)

				-- replace all new line characters with a space which
				-- has the effect of joining all lines together as one long line
				string_8.replace_character (file_text, '%N', ' ')
			else
				lio.put_path_field ("Cannot file", file_path)
				lio.put_new_line
				create file_text.make_empty
			end
		end

feature -- Basic operations

	run
		local
			binary: STRING; code, code_part: INTEGER
		do
			-- split the file text based on the space character and iterate across each number
			across file_text.split (' ') as list loop
				binary := list.item -- assign binary number string to `binary'
				if binary.is_empty then
					-- two consectutive spaces will result in an empty string in the list
					-- so skip empty strings
					do_nothing -- a procedure that does nothing
				else
					code_part := 1
					code := 0
					-- iterate across the digits in reverse order (right to left)
					across binary.mirrored as digit loop
						if digit.item = '1' then
							code := code + code_part
						end
						-- double `code_part' for the next column
						code_part := code_part * 2
					end
					lio.put_character (code.to_character_8)
				end
			end
		end

feature {NONE} -- Internal attributes

	file_text: STRING

feature {NONE} -- Constants

	Description: STRING = "Decode plaintext binary numbers from a text file"
end