note
	description: "Factory for shared naming convention translaters"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 9:46:37 GMT (Tuesday 8th April 2025)"
	revision: "6"

deferred class
	EL_NAMING_CONVENTIONS

inherit
	EL_SHARED_NAME_TRANSLATER_TABLE

	EL_CASE_CONTRACT

feature {NONE} -- Default Conventions

	camel_case: EL_NAME_TRANSLATER
		do
			Result := camel_case_translater ({EL_CASE}.Default_)
		end

	default_english: EL_NAME_TRANSLATER
		do
			Result := english_translater ({EL_CASE}.Default_)
		end

	kebab_case: EL_NAME_TRANSLATER
		do
			Result := kebab_case_translater ({EL_CASE}.Default_)
		end

	snake_case: EL_NAME_TRANSLATER
		do
			Result := snake_case_translater ({EL_CASE}.Default_)
		end

feature {NONE} -- Other Conventions

	camel_case_translater (case_code: NATURAL_8): EL_NAME_TRANSLATER
		require
			valid_case: is_valid_case (case_code)
		do
			Result := Translater_table.item ('%U', case_code)
		end

	english_translater (case_code: NATURAL_8): EL_NAME_TRANSLATER
		require
			valid_case: is_valid_case (case_code)
		do
			Result := Translater_table.item (' ', case_code)
		end

	kebab_case_translater (case_code: NATURAL_8): EL_NAME_TRANSLATER
		require
			valid_case: is_valid_case (case_code)
		do
			Result := Translater_table.item ('-', case_code)
		end

	snake_case_translater (case_code: NATURAL_8): EL_NAME_TRANSLATER
		require
			valid_case: is_valid_case (case_code)
		do
			Result := Translater_table.item ('_', case_code)
		end

end