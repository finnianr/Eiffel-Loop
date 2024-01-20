note
	description: "Set of 2 file paths indexable by ${BOOLEAN} values **True** or **False**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	EL_FILE_PATH_BINARY_SET

inherit
	EL_BOOLEAN_INDEXABLE [FILE_PATH]

create
	make_with_prefix, make, make_with_function, make_with_tuple

convert
	make_with_tuple ({TUPLE [FILE_PATH, FILE_PATH]}), make_with_function ({FUNCTION [BOOLEAN, FILE_PATH]})

feature {NONE} -- Initialization

	make_with_prefix (true_item: FILE_PATH; a_prefix: READABLE_STRING_GENERAL; overlap_count: INTEGER)
		-- make with `item_false' derived from from `true_item' by prefixing `true_item.base' with `a_prefix'
		-- overlapping leading characters of `true_item.base' by `overlap_count'
		require
			base_big_enough: overlap_count.to_boolean implies overlap_count <= true_item.base.count
		local
			false_item: FILE_PATH
		do
			false_item := true_item.twin
			if overlap_count > 0 and overlap_count <= true_item.base.count then
				false_item.base.replace_substring_general (a_prefix, 1, overlap_count)
			else
				false_item.base.prepend_string_general (a_prefix)
			end
			make (false_item, true_item)
		ensure
			valid_item: item_false.base.count = a_prefix.count + (item_true.base.count - overlap_count)
		end

feature -- Status query

	all_exist: BOOLEAN
		do
			Result := for_all (agent {FILE_PATH}.exists)
		end

end