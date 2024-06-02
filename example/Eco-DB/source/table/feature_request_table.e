note
	description: "Feature request table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at hex11software dot com"

	license: "All rights reserved"
	date: "2022-02-02 13:07:47 GMT (Wednesday 2nd February 2022)"
	revision: "4"

class
	FEATURE_REQUEST_TABLE

inherit
	DATA_TABLE [FEATURE_REQUEST]
		undefine
			is_equal, copy
		select
			remove, extend, replace
		end

	FEATURE_REQUEST_LIST
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