note
	description: "List of class feature groups"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-29 9:28:14 GMT (Wednesday 29th May 2024)"
	revision: "8"

class
	FEATURE_GROUP_LIST

inherit
	EL_ARRAYED_LIST [FEATURE_GROUP]

create
	make

feature -- Access

	string_count: INTEGER
		do
			Result := sum_integer (agent {FEATURE_GROUP}.string_count)
		end

	attribute_type (name: ZSTRING): ZSTRING
		local
			found_attribute: BOOLEAN
		do
			push_cursor
			create Result.make_empty
			from start until after or found_attribute loop
				across item.features as list until found_attribute loop
					if attached {ROUTINE_FEATURE} list.item as l_feature then
						if l_feature.name ~ name and then l_feature.is_attribute then
							Result.share (list.item.attribute_type)
							found_attribute := True
						end
					end
				end
				forth
			end
			pop_cursor
		end

feature -- Element change

	add_feature (line: ZSTRING; is_test_set: BOOLEAN)
		local
			l_feature: CLASS_FEATURE; pos_equals: INTEGER
		do
			pos_equals := line.index_of ('=', 1)
			if pos_equals > 1 and then line [pos_equals - 1] /= '#' then
				create {CONSTANT_FEATURE} l_feature.make (line)

			elseif line.starts_with (Setter_shorthand)
				and then attached line.substring_to_reversed (' ') as attribute_name
			then
				create {SETTER_SHORTHAND_FEATURE} l_feature.make (line, attribute_name, agent attribute_type)

			elseif line.has_substring (Insertion_symbol) then
				create {MAKE_ROUTINE_FEATURE} l_feature.make (line, agent attribute_type)

			elseif is_test_set and then line.ends_with (Name_make) then
				create {GENERATE_MAKE_ROUTINE_FOR_EQA_TEST_SET} l_feature.make (Current, line)
			else
				create {ROUTINE_FEATURE} l_feature.make (line)
			end
			last.features.extend (l_feature)
		end

feature {NONE} -- Constants

	Evaluator_class_name: STRING
		once
			Result := ({EL_TEST_SET_EVALUATOR}).name
		end

	Insertion_symbol: ZSTRING
		once
			Result := ":@"
		end

	Setter_shorthand: ZSTRING
		once
			Result := "%T@set"
		end

	Name_make: ZSTRING
		once
			Result := "make"
		end

end