note
	description: "Registry iterable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_REGISTRY_ITERABLE [G]

inherit
	ITERABLE [G]

feature {NONE} -- Initialization

	make (a_reg_path: like reg_path)
		do
			reg_path := a_reg_path
		end

feature {NONE} -- Implementation

	reg_path: DIR_PATH

end