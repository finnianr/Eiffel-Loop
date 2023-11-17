note
	description: "List item substring conversion"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-17 14:00:37 GMT (Friday 17th November 2023)"
	revision: "2"

deferred class
	EL_LIST_ITEM_SUBSTRING_CONVERSION

inherit
	EL_MODULE_CONVERT_STRING

feature -- Integer items

	integer_8_item: INTEGER_8
		do
			Result := Convert_string.substring_to_integer_8 (target, item_lower, item_upper)
		end

	integer_16_item: INTEGER_16
		do
			Result := Convert_string.substring_to_integer_16 (target, item_lower, item_upper)
		end

	integer_item, integer_32_item: INTEGER_32
		do
			Result := Convert_string.substring_to_integer_32 (target, item_lower, item_upper)
		end

	integer_64_item: INTEGER_64
		do
			Result := Convert_string.substring_to_integer_64 (target, item_lower, item_upper)
		end

feature -- Natural items

	natural_8_item: NATURAL_8
		do
			Result := Convert_string.substring_to_natural_8 (target, item_lower, item_upper)
		end

	natural_16_item: NATURAL_16
		do
			Result := Convert_string.substring_to_natural_16 (target, item_lower, item_upper)
		end

	natural_item, natural_32_item: NATURAL
		do
			Result := Convert_string.substring_to_natural_32 (target, item_lower, item_upper)
		end

	natural_64_item: NATURAL_64
		do
			Result := Convert_string.substring_to_natural_64 (target, item_lower, item_upper)
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