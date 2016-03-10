note
	description: "Summary description for {EL_REGISTRY_ITERABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
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
