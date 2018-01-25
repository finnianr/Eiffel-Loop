note
	description: "Eiffel to Paypal and Paypal to Eiffel field name conversion"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-17 22:37:23 GMT (Sunday 17th December 2017)"
	revision: "2"

class
	PP_NAMING_ROUTINES

inherit
	EL_MODULE_NAMING

feature {NONE} -- Implementation

	export_name: like Naming.Default_export
		do
			Result := agent to_paypal_name
		end

	import_name: like Naming.Default_import
		do
			Result := agent Naming.from_upper_camel_case (?, ?, Word_boundary_hints)
		end

	to_paypal_name (name_in, name_out: STRING)
		-- adjust for idiosyncrasy in Paypal naming
		do
			Naming.to_upper_camel_case (name_in, name_out)
			-- insert underscore for `L_' variables
			if name_in.starts_with (once "l_") then
				name_out.insert_character ('_', 2)
			end
		end

feature {NONE} -- Constants

	Word_boundary_hints: ARRAY [STRING]
		once
			Result := << "sub", "button", "date", "url", "0", "code", "item", "time", "id", "now" >>
		end

end
