note
	description: "Group of class features with common export status"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-07 10:38:59 GMT (Wednesday 7th May 2025)"
	revision: "12"

class FEATURE_GROUP inherit ANY

	EL_ZSTRING_CONSTANTS

create
	make, make_from_model

feature {NONE} -- Initialization

	make (a_header: EDITABLE_SOURCE_LINES; a_class_name, a_name: ZSTRING)
		do
			header := a_header; class_name := a_class_name; name := a_name
			create features.make (5)
			is_test_set := a_class_name.ends_with (Test_set_suffix)
		end

	make_from_model (model: SOURCE_MODEL)
		local
			editable_lines: EDITABLE_SOURCE_LINES
		do
			create editable_lines.make_from (model.group_header)
			make (editable_lines, model.class_name, model.group_name)
		end

feature -- Access

	class_name: ZSTRING

	features: EL_ARRAYED_LIST [CLASS_FEATURE]

	header: EDITABLE_SOURCE_LINES

	name: ZSTRING
		-- feature group name found in the comment after feature keyword

	string_count: INTEGER
		do
			Result := features.sum_integer (agent {CLASS_FEATURE}.string_count)
		end

feature -- Status query

	is_test_set: BOOLEAN

feature -- Element change

	add_feature (group_list: FEATURE_GROUP_LIST; line: ZSTRING)
		local
			l_feature: CLASS_FEATURE; pos_equals: INTEGER
		do
			pos_equals := line.index_of ('=', 1)
			if pos_equals > 1 and then line [pos_equals - 1] /= '#' then
				create {CONSTANT_FEATURE} l_feature.make (line)

			elseif line.starts_with (Setter_shorthand)
				and then attached line.substring_to_reversed (' ') as attribute_name
			then
				create {SETTER_SHORTHAND_FEATURE} l_feature.make (line, attribute_name, agent group_list.attribute_type)

			elseif line.has_substring (Insertion_symbol) then
				create {MAKE_ROUTINE_FEATURE} l_feature.make (line, agent group_list.attribute_type)

			elseif is_eqa_make (line) then
				create {GENERATE_MAKE_ROUTINE_FOR_EQA_TEST_SET} l_feature.make (group_list, line)

			elseif is_eqa_test_procedure (line) then
				create {TEST_PROCEDURE} l_feature.make (class_name, line)

			else
				create {ROUTINE_FEATURE} l_feature.make (line)
			end
			features.extend (l_feature)
		end

	append (line: ZSTRING)
		do
			features.last.lines.extend (line)
		end

feature {NONE} -- Implementation

	code_line (line: ZSTRING): ZSTRING
		-- line with leading tab removed and right adjusted
		do
			if line.leading_occurrences ('%T') = 1 then
				Result := Line_buffer.copied_substring (line, 2, line.count)
				Result.right_adjust
			else
				Result := Empty_string
			end
		end

	is_eqa_make (line: ZSTRING): BOOLEAN
		-- `True' if line is `make' routine for test conforming to `EL_EQA_TEST_SET'
		do
			if is_test_set and then name.starts_with_general (Initial) then
				Result := code_line (line) ~ Name_make
			end
		end

	is_eqa_test_procedure (a_line: ZSTRING): BOOLEAN
		-- `True' if line is a `test_*' procedure in a class conforming to `EL_EQA_TEST_SET'
		do
			if is_test_set and then attached code_line (a_line) as line then
				Result := line.starts_with (Test_prefix) and then line.is_code_identifier
			end
		end

feature {NONE} -- Constants

	Initial: STRING = "Initial"

	Insertion_symbol: ZSTRING
		once
			Result := ":@"
		end

	Line_buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

	Name_make: ZSTRING
		once
			Result := "make"
		end

	Setter_shorthand: ZSTRING
		once
			Result := "%T@set"
		end

	Test_prefix: ZSTRING
		once
			Result := "test_"
		end

	Test_set_suffix: ZSTRING
		once
			Result := "_TEST_SET"
		end


end