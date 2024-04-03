note
	description: "Sortable arrayed list"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-03 16:00:39 GMT (Wednesday 3rd April 2024)"
	revision: "16"

class
	EL_SORTABLE_ARRAYED_LIST [G -> COMPARABLE]

inherit
	EL_ARRAYED_LIST [G]
		redefine
			sort
		end

	PART_COMPARATOR [G]
		undefine
			copy, is_equal
		end

create
	make, make_empty, make_sorted, make_default_filled, make_filled,
	make_from_for, make_from, make_from_if,
	make_joined, make_from_special, make_from_array,
	make_from_sub_list, make_from_tuple

convert
	make_sorted ({CONTAINER [G]})

feature {NONE} -- Initialization

	make_sorted (container: CONTAINER [G])
		-- make sorted using object comparison
		do
			make_from (container)
			ascending_sort
		end

feature -- Basic operations

	sort (in_ascending_order: BOOLEAN)
		local
			quick: QUICK_SORTER [G]
		do
			create quick.make (Current)
			if in_ascending_order then
				quick.sort (Current)
			else
				quick.reverse_sort (Current)
			end
		end

feature {NONE} -- Implementation

	less_than (u, v: G): BOOLEAN
		do
			Result := u.is_less (v)
		end

note
	descendants: "[
			EL_SORTABLE_ARRAYED_LIST [G -> ${COMPARABLE}]
				${EL_FILE_PATH_LIST}
				${EL_DIRECTORY_PATH_LIST}
					${EL_NATIVE_DIRECTORY_PATH_LIST}
				${EL_FILE_MANIFEST_LIST}
				${EL_IMMUTABLE_STRING_8_LIST}
					${EL_IMMUTABLE_UTF_8_LIST}
				${EL_STRING_LIST [S -> STRING_GENERAL create make end]}
					${EL_STRING_8_LIST}
						${EVOLICITY_VARIABLE_REFERENCE}
							${EVOLICITY_FUNCTION_REFERENCE}
						${AIA_CANONICAL_REQUEST}
					${EL_STRING_32_LIST}
					${EL_ZSTRING_LIST}
						${EL_XHTML_STRING_LIST}
						${XML_TAG_LIST}
							${XML_PARENT_TAG_LIST}
							${XML_VALUE_TAG_PAIR}
						${TB_HTML_LINES}
						${EL_ERROR_DESCRIPTION}
							${EL_COMMAND_ARGUMENT_ERROR}
					${EL_TEMPLATE_LIST* [S -> STRING_GENERAL create make end, KEY -> READABLE_STRING_GENERAL]}
						${EL_SUBSTITUTION_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]}
							${EL_STRING_8_TEMPLATE}
							${EL_STRING_32_TEMPLATE}
							${EL_ZSTRING_TEMPLATE}
						${EL_TEMPLATE [S -> STRING_GENERAL create make, make_empty end]}
							${EL_DATE_TEXT_TEMPLATE}
	]"
end