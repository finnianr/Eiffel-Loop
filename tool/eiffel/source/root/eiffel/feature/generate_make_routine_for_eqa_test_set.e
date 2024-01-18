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
	date: "2023-03-11 9:54:15 GMT (Saturday 11th March 2023)"
	revision: "9"

class
	GENERATE_MAKE_ROUTINE_FOR_EQA_TEST_SET

inherit
	CLASS_FEATURE
		rename
			make as make_feature
		end

	EVOLICITY_SERIALIZEABLE_AS_ZSTRING
		rename
			as_text as make_code_text
		end

create
	make

feature {NONE} -- Initialization

	make (a_feature_group_list: like feature_group_list; line: ZSTRING)
		do
			feature_group_list := a_feature_group_list
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
			create Result.make (<<
				["name_list", agent get_test_name_list]
			>>)
		end

	get_test_name_list: EL_ZSTRING_LIST
		local
			group_name: ZSTRING
		do
			create Result.make (20)
			across feature_group_list as group loop
				group_name := group.item.name.as_lower
				if across Test_endings as ending some group_name.ends_with (ending.item) end then
					across group.item.features as l_feature loop
						if l_feature.item.name.starts_with (Test_prefix) then
							Result.extend (l_feature.item.name.substring_end (Test_prefix.count + 1))
						end
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

	Test_endings: ARRAY [ZSTRING]
		once
			Result := << "test", "tests" >>
		end

	Test_prefix: ZSTRING
		once
			Result := "test_"
		end

end