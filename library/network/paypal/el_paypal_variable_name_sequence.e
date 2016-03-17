note
	description: "Summary description for {EL_PAYPAL_SEQUENTIAL_VARIABLE_NAME}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 16:32:24 GMT (Sunday 20th December 2015)"
	revision: "6"

deferred class
	EL_PAYPAL_VARIABLE_NAME_SEQUENCE

feature {NONE} -- Implementation

	new_name: ZSTRING
		do
			Result := name_prefix + count.out
		end

	name_prefix: ZSTRING
		deferred
		end

feature -- Measurement

	count: INTEGER
		deferred
		end
end
