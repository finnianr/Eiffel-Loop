note
	description: "Summary description for {EL_XML_RECORD_DELETE_OPERATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

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
			make_serializeable
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
