note
	description: "Translating: CamelCase <--> camel_case"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 7:52:15 GMT (Monday 23rd September 2024)"
	revision: "9"

class
	EL_CAMEL_CASE_TRANSLATER

inherit
	EL_NAME_TRANSLATER
		redefine
			default_create, inform
		end

create
	make, make_case

convert
	make_case ({NATURAL_8})

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			create eiffel_table.make (7)
		end

feature -- Conversion

	exported (eiffel_name: READABLE_STRING_8): STRING
		-- `eiffel_name' exported to a foreign naming convention
		do
			create Result.make (eiffel_name.count - eiffel_name.occurrences ('_'))
			inspect foreign_case
				when {EL_CASE}.lower then
					to_camel_case_lower (eiffel_name, Result)

				when {EL_CASE}.upper then
					to_camel_case_upper (eiffel_name, Result)

				when {EL_CASE}.Proper then
					to_camel_case (eiffel_name, Result, True)
			else
				to_camel_case (eiffel_name, Result, False)
			end
		end

	imported (foreign_name: READABLE_STRING_8): STRING
		-- `foreign_name' translated to Eiffel attribute-naming convention
		do
			inspect foreign_case
				when {EL_CASE}.lower, {EL_CASE}.upper then
					if eiffel_table.has_key (Name_buffer.copied_lower (foreign_name)) then
						Result := eiffel_table.found_item
					else
						Result := Empty_name
					end
			else
				Result := Name_buffer.empty
				from_camel_case (foreign_name, Result)
				Result := Result.twin
			end
		end

feature -- Element change

	inform (eiffel_name: IMMUTABLE_STRING_8)
		do
			inspect foreign_case
				when {EL_CASE}.lower, {EL_CASE}.upper then
					eiffel_table.put (eiffel_name, new_camel_name (eiffel_name))
			else
			end
		end

feature {NONE} -- Implementation

	new_camel_name (eiffel_name: READABLE_STRING_8): STRING
		do
			create Result.make_from_string (eiffel_name)
			Result.prune_all ('_')
		end

feature {NONE} -- Internal attributes

	eiffel_table: EL_HASH_TABLE [STRING, STRING]

end