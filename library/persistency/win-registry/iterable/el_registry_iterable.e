note
	description: "Registry iterable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

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

	reg_path: EL_DIR_PATH

end