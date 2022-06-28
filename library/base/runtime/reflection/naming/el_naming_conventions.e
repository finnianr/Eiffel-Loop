note
	description: "Factory for shared naming convention translaters"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-26 9:30:41 GMT (Sunday 26th June 2022)"
	revision: "1"

deferred class
	EL_NAMING_CONVENTIONS

inherit
	EL_SHARED_NAME_TRANSLATER_TABLE

feature {NONE} -- Default Conventions

	camel_case: EL_NAME_TRANSLATER
		do
			Result := camel_case_translater (Case.Default)
		end

	default_english: EL_NAME_TRANSLATER
		do
			Result := english_translater (Case.Default)
		end

	kebab_case: EL_NAME_TRANSLATER
		do
			Result := kebab_case_translater (Case.Default)
		end

	snake_case: EL_NAME_TRANSLATER
		do
			Result := snake_case_translater (Case.Default)
		end

feature {NONE} -- Other Conventions

	camel_case_translater (case_code: NATURAL): EL_NAME_TRANSLATER
		require
			valid_case: Case.Valid.has (case_code)
		do
			Result := Translater_table.item ('%U', case_code)
		end

	english_translater (case_code: NATURAL): EL_NAME_TRANSLATER
		require
			valid_case: Case.Valid.has (case_code)
		do
			Result := Translater_table.item (' ', case_code)
		end

	kebab_case_translater (case_code: NATURAL): EL_NAME_TRANSLATER
		require
			valid_case: Case.Valid.has (case_code)
		do
			Result := Translater_table.item ('-', case_code)
		end

	snake_case_translater (case_code: NATURAL): EL_NAME_TRANSLATER
		require
			valid_case: Case.Valid.has (case_code)
		do
			Result := Translater_table.item ('_', case_code)
		end

end