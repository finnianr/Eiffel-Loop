note
	description: "A queryable list of AIA credentials. See class ${AIA_CREDENTIAL}."
	notes: "[
		Creating an instance of this class automatically makes it globally shared from class
		${AIA_SHARED_CREDENTIAL_LIST}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	AIA_CREDENTIAL_LIST

inherit
	EL_QUERYABLE_ARRAYED_LIST [AIA_CREDENTIAL]
		redefine
			make_queryable
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

create
	make, make_from_array

feature {NONE} -- Initialization

	make_queryable
		do
			make_solitary
			create last_query_items.make (0)
		end

end