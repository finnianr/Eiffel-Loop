note
	description: "Translating: CamelCase <--> camel_case"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-15 15:29:53 GMT (Wednesday 15th June 2022)"
	revision: "1"

class
	EL_CAMEL_CASE_TRANSLATER

inherit
	EL_NAME_TRANSLATER
		redefine
			default_create, inform
		end

create
	make, make_lower, make_upper, make_title

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			create eiffel_table.make (7)
		end

feature -- Conversion

	exported (eiffel_name: STRING): STRING
		-- `eiffel_name' exported to a foreign naming convention
		do
			create Result.make (eiffel_name.count)
			inspect foreign_case
				when Case_lower then
					Naming.to_camel_case_lower (eiffel_name, Result)

				when Case_upper then
					Naming.to_camel_case_upper (eiffel_name, Result)

				when Case_title then
					Naming.to_camel_case (eiffel_name, Result, True)
			else
				Naming.to_camel_case (eiffel_name, Result, False)
			end
		end

	imported (foreign_name: STRING): STRING
		-- `foreign_name' translated to Eiffel attribute-naming convention
		do
			inspect foreign_case
				when Case_lower, Case_upper then
					if eiffel_table.has_key (Name_buffer.copied_lower (foreign_name)) then
						Result := eiffel_table.found_item
					end
			else
				Result := Name_buffer.empty
				Naming.from_camel_case (foreign_name, Result)
				Result := Result.twin
			end
		end

feature -- Element change

	inform (eiffel_name: STRING)
		do
			inspect foreign_case
				when Case_lower, Case_upper then
					eiffel_table.put (eiffel_name, new_camel_name (eiffel_name))
			else
			end
		end

feature {NONE} -- Implementation

	new_camel_name (eiffel_name: STRING): STRING
		do
			Result := eiffel_name.twin
			Result.prune_all ('_')
		end

feature {NONE} -- Internal attributes

	eiffel_table: HASH_TABLE [STRING, STRING]

end