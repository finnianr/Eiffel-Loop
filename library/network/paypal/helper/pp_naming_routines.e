note
	description: "Eiffel to Paypal and Paypal to Eiffel field name conversion"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-11 8:09:33 GMT (Friday 11th May 2018)"
	revision: "4"

deferred class
	PP_NAMING_ROUTINES

inherit
	EL_MODULE_NAMING

feature {NONE} -- Implementation

	empty_name_out: STRING
		deferred
		end

	to_paypal_name (name_in: STRING; keeping_ref: BOOLEAN): STRING
		-- adjust for idiosyncrasy in Paypal naming
		do
			Result := empty_name_out
			Naming.to_upper_camel_case (name_in, Result)
			-- insert underscore for `L_' variables
			if name_in.starts_with (once "l_") then
				Result.insert_character ('_', 2)
			end
			if keeping_ref then
				Result := Result.twin
			end
		end

	import_from_upper_camel_case (name_in, name_out: STRING)
		do
			Naming.from_upper_camel_case (name_in, name_out, Word_boundary_hints)
		end

feature {NONE} -- Constants

	Word_boundary_hints: ARRAY [STRING]
		once
			Result := << "sub", "button", "date", "url", "0", "code", "item", "time", "id", "now" >>
		end

end
