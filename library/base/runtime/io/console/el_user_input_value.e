note
	description: "Get user input value for type G convertable by [$source EL_STRING_CONVERSION_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_USER_INPUT_VALUE [G]

inherit
	ANY

	EL_MODULE_USER_INPUT

	EL_MODULE_CONVERT_STRING

	EL_MODULE_LIO

	EL_SHARED_CLASS_ID

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

	make_valid (a_prompt, a_invalid_response: READABLE_STRING_GENERAL; is_value_valid: PREDICATE [G])
		do
			invalid_response := a_invalid_response; is_valid_value := is_value_valid
			make (a_prompt)
		end

	make_drag_and_drop
		require
			valid_type: Convert_string.has_converter ({G}) and then Convert_string.found_item.is_path
		do
			make ("Drag and drop a ")
			prompt.append_string_general (converter.type_description)
		end

feature -- Access

	value: G
		local
			line: ZSTRING; done: BOOLEAN; operands: TUPLE [G]
		do
			from until done loop
				if is_path_type then
					line := User_input.path (prompt)
				else
					line := User_input.line (prompt)
				end
				lio.put_new_line

				if converter.is_convertible (line) and then attached converter.as_type (line) as v then
					Result := v; operands := [v]
					if attached {EL_PATH} v as path
						and then path_must_exist and then not path.exists
					then
						lio.put_labeled_string (Bad_input, Does_not_exist #$ [value_description])
						lio.put_new_line

					elseif attached is_valid_value as test and then test.valid_operands (operands) then
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

	value_type: TYPE [G]

	value_description: STRING
		-- Eg. 32-bit integer
		do
			Result := converter.type_description
		end

feature -- Status query

	is_path_type: BOOLEAN
		do
			Result := Class_id.path_types.has (value_type.type_id)
		end

	path_must_exist: BOOLEAN

feature -- Status change

	check_existence
		do
			path_must_exist := True
		ensure
			appropriate_type: path_must_exist implies is_path_type
		end

feature {NONE} -- Internal attributes

	converter: EL_READABLE_STRING_GENERAL_TO_TYPE [G]

	invalid_response: READABLE_STRING_GENERAL

	is_valid_value: detachable PREDICATE [G]

	prompt: ZSTRING

feature {NONE} -- Constants

	Does_not_exist: ZSTRING
		once
			Result := "The %S does not exist"
		end

	Bad_input: STRING = "Bad input"

	Not_convertible: ZSTRING
		once
			Result := "[
				"#" is not a valid #
			]"
		end

end