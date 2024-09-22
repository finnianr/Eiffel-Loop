note
	description: "Xpath step token table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:05:12 GMT (Sunday 22nd September 2024)"
	revision: "12"

class
	EL_XPATH_TOKEN_TABLE

inherit
	EL_STRING_8_TABLE [NATURAL_16]
		rename
			make as make_sized
		end

	EL_XPATH_NODE_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			make_equal (n)
			across 1 |..| Type_processing_instruction as type loop
				extend (type.item.to_natural_16, Node_name [type.item])
			end
		end

feature -- Access

	code (xpath_step: READABLE_STRING_8): NATURAL_16
			-- token value of xpath step
		do
			if has_key (xpath_step) then
				Result := found_item
			else
				Result := (count + 1).to_natural_16
				extend (Result, xpath_step.twin)
			end
		ensure
			not_using_reserved_id: inserted implies Result.as_integer_32 > Type_processing_instruction
		end

end