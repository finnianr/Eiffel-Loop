note
	description: "Sends a desktop notification warning of an error"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-29 11:50:17 GMT (Friday 29th March 2024)"
	revision: "2"

deferred class
	EL_NOTIFY_SEND_ERROR_COMMAND_I

inherit
	EL_PARSED_OS_COMMAND [TUPLE [urgency, error, message: STRING]]
		export
			{ANY} put_string
		redefine
			put_string
		end

	EL_OS_DEPENDENT

feature -- Element change

	put_string (variable_name: READABLE_STRING_8; value: READABLE_STRING_GENERAL)
		require else
			valid_urgency_string: variable_name = Var.urgency implies valid_urgency (value)
		do
			Precursor (variable_name, value)
		end

feature -- Contract Support

	valid_urgency (value: READABLE_STRING_GENERAL): BOOLEAN
		local
			valid_values: EL_ARRAYED_LIST [IMMUTABLE_STRING_8]
		do
			create valid_values.make_from_tuple (Urgency)
			Result := across valid_values as list some list.item = value end
		end

feature {NONE} -- Implementation

	urgency_list: STRING
		deferred
		end

feature -- Constants

	Urgency: TUPLE [low, normal, critical: IMMUTABLE_STRING_8]
		-- urgency=LEVEL Specifies the urgency level.
		-- Unix: low, normal, critical
		-- Windows: vbOKOnly, vbCritical, vbQuestion
		once
			create Result
			Tuple.fill_immutable (Result, urgency_list)
		end

end