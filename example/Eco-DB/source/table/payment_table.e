note
	description: "Payment table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-09 9:53:36 GMT (Sunday 9th June 2024)"
	revision: "5"

class
	PAYMENT_TABLE

inherit
	DATA_TABLE [PAYPAL_PAYMENT]
		undefine
			is_equal, copy
		select
			remove, extend, replace
		end

	PAYMENT_LIST
		rename
			make as make_chain_implementation,
			remove as chain_remove,
			extend as chain_extend,
			replace as chain_replace
		undefine
			append
		end

create
	make

end