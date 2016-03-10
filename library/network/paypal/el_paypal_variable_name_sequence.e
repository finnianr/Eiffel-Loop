note
	description: "Summary description for {EL_PAYPAL_SEQUENTIAL_VARIABLE_NAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_PAYPAL_VARIABLE_NAME_SEQUENCE

feature {NONE} -- Implementation

	new_name: ASTRING
		do
			Result := name_prefix + count.out
		end

	name_prefix: ASTRING
		deferred
		end

feature -- Measurement

	count: INTEGER
		deferred
		end
end
