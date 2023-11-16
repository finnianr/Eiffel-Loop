note
	description: "List item substring conversion"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-16 15:43:36 GMT (Thursday 16th November 2023)"
	revision: "1"

deferred class
	EL_LIST_ITEM_SUBSTRING_CONVERSION

inherit
	EL_MODULE_CONVERT_STRING

feature -- Integer items

	integer_8_item: INTEGER
		do
			Result := Convert_string.substring_to_integer_8 (target, item_lower, item_upper)
		end

	integer_16_item: INTEGER
		do
			Result := Convert_string.substring_to_integer_16 (target, item_lower, item_upper)
		end

	integer_item, integer_32_item: INTEGER
		do
			Result := Convert_string.substring_to_integer_32 (target, item_lower, item_upper)
		end

feature -- Natural items

	natural_item, natural_32_item: NATURAL
		do
			Result := Convert_string.substring_to_natural_32 (target, item_lower, item_upper)
		end

feature -- Real numbers

	double_item, real_64_item: DOUBLE
		do
			Result := Convert_string.substring_to_real_64 (target, item_lower, item_upper)
		end

	real_item, real_32_item: DOUBLE
		do
			Result := Convert_string.substring_to_real_32 (target, item_lower, item_upper)
		end

feature {NONE} -- Deferred

	item_lower: INTEGER
		deferred
		end

	item_upper: INTEGER
		deferred
		end

	target: READABLE_STRING_GENERAL
		deferred
		end
end