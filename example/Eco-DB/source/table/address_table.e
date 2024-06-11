note
	description: "Address table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-09 9:53:36 GMT (Sunday 9th June 2024)"
	revision: "8"

class
	ADDRESS_TABLE

inherit
	DATA_TABLE [ADDRESS]
		rename
			item as address_item
		undefine
			is_equal, copy
		redefine
			make
		select
			remove, extend, replace
		end

	ADDRESS_LIST
		rename
			make as make_chain_implementation,
			remove as chain_remove,
			extend as chain_extend,
			replace as chain_replace
		undefine
			append
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

create
	make

feature {NONE} -- Initialization

	make (config: DATABASE_CONFIGURATION)
		do
			make_solitary
			Precursor (config)
		end

end