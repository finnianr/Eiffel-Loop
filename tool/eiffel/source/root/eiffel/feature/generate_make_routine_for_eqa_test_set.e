note
	description: "[
		Generate make routine content for test set conforming to ${EL_EQA_TEST_SET}
		
		For example:
		
			make
				-- initialize `test_table'
				do
					make_named (<<
						["file_editing", agent test_file_editing]
					>>)
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-07 8:35:26 GMT (Wednesday 7th May 2025)"
	revision: "15"

class
	GENERATE_MAKE_ROUTINE_FOR_EQA_TEST_SET

inherit
	CLASS_FEATURE
		rename
			make as make_feature
		end

	EVC_SERIALIZEABLE_AS_ZSTRING
		rename
			as_text as make_code_text
		end

create
	make

feature {NONE} -- Initialization

	make (a_group_list: FEATURE_GROUP_LIST; line: ZSTRING)
		do
			feature_group_list := a_group_list
			make_feature (line)
			make_default
		end

feature -- Element change

	expand_shorthand
		do
			lines.wipe_out
			lines.append_sequence (routine_lines)
		end

feature {NONE} -- Implementation

	getter_function_table: like getter_functions
			--
		do
			create Result
			Result ["name_list"] := agent get_test_name_list
		end

	get_test_name_list: EL_ZSTRING_LIST
		do
			create Result.make (20)
			across feature_group_list as group loop
				across group.item.features as list loop
					if attached {TEST_PROCEDURE} list.item as procedure then
						Result.extend (procedure.test_name)
					end
				end
			end
		end

	routine_lines: EL_ZSTRING_LIST
		local
			l_found: BOOLEAN
		do
			create Result.make_with_lines (make_code_text)
--			Remove comma on the last tuple item
			if attached Result as list then
				from list.finish until l_found or list.before loop
					if list.item.has (']') then
						list.item.prune_all_trailing (',')
						l_found := True
					else
						list.back
					end
				end
			end
			Result.indent (1)
			Result.extend (Empty_string)
		end

feature {NONE} -- Internal attributes

	feature_group_list: FEATURE_GROUP_LIST

feature {NONE} -- Constants

	Template: STRING = "[
		make
			-- initialize `test_table'
			do
				make_named (<<
				#foreach $name in $name_list loop
					["$name", agent test_$name],
				#end
				>>)
			end
	]"

end