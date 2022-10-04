note
	description: "Get user input value for type G convertable by [$source EL_STRING_CONVERSION_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 15:34:49 GMT (Tuesday 4th October 2022)"
	revision: "1"

class
	EL_USER_INPUT_VALUE [G]

inherit
	ANY

	EL_MODULE_USER_INPUT

	EL_MODULE_CONVERT_STRING

	EL_MODULE_LIO

	EL_SHARED_CLASS_ID

create
	make, make_valid

convert
	value: {G}

feature {NONE} -- Initialization

	make (a_prompt: READABLE_STRING_GENERAL)
		require
			convertable_type: Convert_string.has (value_type.type_id)
		do
			prompt := a_prompt
		end

	make_valid (a_prompt, a_invalid_response: READABLE_STRING_GENERAL; is_value_valid: PREDICATE [G])
		require
			convertable_type: Convert_string.has (value_type.type_id)
		do
			prompt := a_prompt; invalid_response := a_invalid_response; is_valid_value := is_value_valid
		end

feature -- Access

	value: G
		local
			line, name: ZSTRING; done: BOOLEAN; operands: TUPLE [G]
		do
			from until done loop
				if is_path_type then
					line := User_input.path (prompt)
				else
					line := User_input.line (prompt)
				end
				lio.put_new_line

				if Convert_string.is_convertible (line, value_type)
					and then attached {G} Convert_string.to_type (line, value_type) as v
				then
					Result := v; operands := [v]
					if attached {EL_PATH} v as path
						and then Path_type.has_key (path.generating_type)
						and then path_must_exist and then not path.exists
					then
						lio.put_labeled_string (Bad_input, Does_not_exist #$ [Path_type.found_item])
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
					lio.put_labeled_string (Bad_input, Not_convertible #$ [line, value_type.name])
					lio.put_new_line
				end
			end
		end

	value_type: TYPE [G]
		do
			Result := {G}
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
		end

feature {NONE} -- Internal attributes

	invalid_response: READABLE_STRING_GENERAL

	is_valid_value: detachable PREDICATE [G]

	prompt: READABLE_STRING_GENERAL

feature {NONE} -- Constants

	Path_type: EL_HASH_TABLE [STRING, TYPE [EL_PATH]]
		once
			create Result.make (<<
				[{DIR_PATH}, "directory"], [{FILE_PATH}, "file"]
			>>)
		end

	Does_not_exist: ZSTRING
		once
			Result := "The %S does not exist"
		end

	Bad_input: STRING = "Bad input"

	Not_convertible: ZSTRING
		once
			Result := "[
				"#" is not convertable to # type
			]"
		end

end