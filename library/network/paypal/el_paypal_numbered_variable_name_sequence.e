note
	description: "Summary description for {EL_PAYPAL_NUMBERED_VARIABLE_NAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_PAYPAL_NUMBERED_VARIABLE_NAME_SEQUENCE

inherit
	EL_PAYPAL_VARIABLE_NAME_SEQUENCE
		redefine
			new_name
		end

feature {NONE} -- Initialization

	make (a_number: like number)
		require
			valid_id: a_number >= 0 and a_number <= 9
		do
			number := a_number
		end

feature {NONE} -- Implementation

	new_name: ASTRING
		local
			pos_qmark: INTEGER
		do
			Result := Precursor
			pos_qmark := Result.index_of ('?', 1)
			if pos_qmark > 0 then
				Result [pos_qmark] := number.out [1]
			end
		end

	name_prefix: ASTRING
		deferred
		ensure then
			valid_name: Result.has ('?')
		end

	number: INTEGER

end
