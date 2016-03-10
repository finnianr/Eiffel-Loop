note
	description: "Summary description for {EL_PAYPAL_API_ARGUMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_HTTP_NAME_VALUE_PARAMETER

inherit
	EL_HTTP_PARAMETER
		rename
			extend as extend_table
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: like name; a_value: like value)
		do
			name := a_name; value := a_value
		end

feature -- Access

	name: ASTRING

	value: ASTRING

feature {EL_HTTP_PARAMETER} -- Implementation

	extend_table (table: EL_HTTP_HASH_TABLE)
		do
			table.set_string (name, value)
		end
end
