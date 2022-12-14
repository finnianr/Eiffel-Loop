note
	description: "Default reflected reference field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-13 16:27:50 GMT (Tuesday 13th December 2022)"
	revision: "1"

class
	EL_REFLECTED_REFERENCE_ANY

inherit
	EL_REFLECTED_REFERENCE [ANY]
		redefine
			is_abstract, is_storable_type
		end

create
	make

feature {NONE} -- Constants

	Is_abstract: BOOLEAN = True
		-- `True' if field type is deferred

	Is_storable_type: BOOLEAN = False
		-- is type storable using `EL_STORABLE' interface

end