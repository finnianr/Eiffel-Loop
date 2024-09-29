note
	description: "Get user input value for type G convertable by ${EL_STRING_CONVERSION_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-28 8:01:35 GMT (Saturday 28th September 2024)"
	revision: "9"

class
	EL_USER_INPUT_VALUE [G]

inherit
	ANY

	EL_MODULE_CONVERT_STRING; EL_MODULE_EIFFEL; EL_MODULE_LIO; EL_MODULE_USER_INPUT

	EL_SHARED_CLASS_ID

	EL_PROTOCOL_CONSTANTS

create
	make, make_valid, make_drag_and_drop

convert
	value: {G}

feature {NONE} -- Initialization

	make (a_prompt: READABLE_STRING_GENERAL)
		require
			convertable_type: Convert_string.has_converter ({G})
		do
			create prompt.make_from_general (a_prompt)
			value_type := {G}
			if Convert_string.has_converter (value_type)
				and then attached {like converter} Convert_string.found_item as c
			then
				converter := c
			end
		end

	make_drag_and_drop
		require
			valid_type: Convert_string.has_converter ({G}) and then Convert_string.found_item.is_path
		do
			make ("Drag and drop a ")
			prompt.append_string_general (converter.type_description)
		end

	make_valid (a_prompt, a_invalid_response: READABLE_STRING_GENERAL; a_value_valid: PREDICATE [G])
		do
			invalid_response := a_invalid_response; valid_value := a_value_valid
			make (a_prompt)
		end

feature -- Access

	value: G
		local
			line: ZSTRING; done: BOOLEAN; operands: TUPLE [G]
		do
			escape_pressed := False
			from until done loop
				line := line_input
				if User_input.escape_pressed then
					line := Zero -- we still need to return a value
					escape_pressed := True
				end
				if converter.is_convertible (line) and then attached converter.as_type (line) as v then
					Result := v; operands := [v]
					if line = Zero then
						done := True

					elseif attached {EL_PATH} v as path
						and then path_must_exist and then not path.exists
					then
						lio.put_labeled_string (Bad_input, Does_not_exist #$ [value_description])
						lio.put_new_line

					elseif attached valid_value as test and then test.valid_operands (operands) then
						test.set_operands (operands)
						test.apply
						if test.last_result then
							done := True
						else
							if attached {ZSTRING} invalid_response as template
								and then template.occurrences ('%S') = 1
							then
								lio.put_labeled_string (Bad_input, template  #$ [Result])
								lio.put_new_line
							else
								lio.put_line (invalid_response)
							end
						end
					else
						done := True
					end
				else
					lio.put_labeled_string (Bad_input, Not_convertible #$ [line, value_description])
					lio.put_new_line
				end
			end
		end

	value_description: STRING
		-- Eg. 32-bit integer
		do
			Result := converter.type_description
		end

	value_type: TYPE [G]

feature -- Status query

	is_path_type: BOOLEAN
		do
			Result := Eiffel.field_conforms_to (value_type.type_id, Class_id.EL_PATH)
		end

	is_uri_type: BOOLEAN
		do
			Result := Eiffel.field_conforms_to (value_type.type_id, Class_id.EL_URI_PATH)
		end

	path_must_exist: BOOLEAN

feature -- Status change

	check_existence
		do
			path_must_exist := True
		ensure
			appropriate_type: path_must_exist implies is_path_type
		end

	escape_pressed: BOOLEAN

feature {NONE} -- Implementation

	line_input: ZSTRING
		do
			if is_path_type then
				Result := User_input.path (prompt)
--				Allow base to equal "quit" for URI paths by ensuring preconditions met
				if is_uri_type and then not Result.has_substring (Colon_slash_x2) then
					if not Result.has_first ('/') then
						Result.prepend_character ('/')
					end
					Result.prepend_string_general (Protocol.file + Colon_slash_x2)
				end
			else
				Result := User_input.line (prompt)
			end
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	converter: EL_READABLE_STRING_GENERAL_TO_TYPE [G]

	invalid_response: READABLE_STRING_GENERAL

	valid_value: detachable PREDICATE [G]

	prompt: ZSTRING

feature {NONE} -- Constants

	Bad_input: STRING = "Bad input"

	Does_not_exist: ZSTRING
		once
			Result := "The %S does not exist"
		end

	Zero: ZSTRING
		once
			Result := "0"
		end

	Not_convertible: ZSTRING
		once
			Result := "[
				"#" is not a valid #
			]"
		end

end