note
	description: "[
		Binary state object that can be associated with a descriptive name pair. `on' or `off' for example.
	]"
	notes: "[
		In a descendant, rename `item' to the "true name", `on' for example, and redefine `false_name' as the opposite,
		which in this example would be `off'.
	]"
	tests: "Class [$source PP_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-04 13:16:22 GMT (Friday 4th October 2019)"
	revision: "7"

class
	EL_REFLECTIVE_BOOLEAN_REF

inherit
	BOOLEAN_REF
		redefine
			out
		end

	EL_REFLECTIVE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		undefine
			out
		end

	EL_MAKEABLE_FROM_STRING_8
		rename
			make as make_from_string
		undefine
			out
		end

create
	make, make_default, make_from_string

convert
	make ({BOOLEAN}), item: {BOOLEAN}

feature {NONE} -- Initialization

	make (a_item: BOOLEAN)
		do
			item := a_item
		end

	make_default
		do
		end

	make_from_string (value: STRING)
		do
			set_from_string (value)
		end

feature -- Access

	out, to_string: STRING
		do
			if item then
				Result := true_name
			else
				Result := false_name
			end
		end

feature -- Element change

	set_from_string (value: READABLE_STRING_GENERAL)
		do
			item := value.is_case_insensitive_equal (true_name)
		ensure then
			reversible: value.is_case_insensitive_equal (out)
		end

feature {NONE} -- Implementation

	true_name: STRING
		do
			Result := Meta_data_by_type.item (Current).field_array.item (1).name
		end

	false_name: STRING
		once
			Result := "False"
		end

end
