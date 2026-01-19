note
	description: "List of class feature groups"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-07 7:46:30 GMT (Wednesday 7th May 2025)"
	revision: "9"

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

	add_feature (line: ZSTRING)
		do
			if count > 0 then
				last.add_feature (Current, line)
			end
		end

feature {NONE} -- Constants

	Evaluator_class_name: STRING
		once
			Result := ({EL_TEST_SET_EVALUATOR}).name
		end

end