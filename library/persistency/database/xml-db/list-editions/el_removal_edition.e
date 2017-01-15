note
	description: "Summary description for {EL_XML_RECORD_DELETE_OPERATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-11-17 12:17:02 GMT (Thursday 17th November 2016)"
	revision: "2"

class
	EL_REMOVAL_EDITION [STORABLE_TYPE -> EL_STORABLE_XML_ELEMENT]

inherit
	EL_XML_ELEMENT_EDITION [STORABLE_TYPE]

create
	make, default_create

feature {NONE} -- Initialization

	make (a_index: INTEGER)
			--
		do
			make_default
			index := a_index
		end

feature {NONE} -- Implementation

	apply (target: LIST [STORABLE_TYPE])
			-- Apply removal transaction to target list
		do
			target.go_i_th (index)
			target.remove
		end

feature {NONE} -- Constants

	Template: STRING = "[
		<edition-remove index="$index"/>
	]"

end
