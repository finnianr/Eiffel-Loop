note
	description: "Summary description for {EL_LOCALE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:01 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_LOCALE_ROUTINES

inherit
	EL_CROSS_PLATFORM [EL_LOCALE_ROUTINES_IMPL]

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_FILE

create
	make_platform

feature -- Conversion

	translation (key: STRING): STRING
			--
		local
			table: EL_TRANSLATION_TABLE
		do
			translations.lock
--			synchronized
				table := translations.item
				table.search (key)
				if table.found then
					Result := table.found_item
				else
					Result := key + "*"
				end
--			end
			translations.unlock
		end

	translation_array (keys: ARRAY [STRING]): ARRAY [STRING]
			--
		local
			i: INTEGER
		do
			create Result.make (keys.lower, keys.upper)
			from i := keys.lower until i > keys.count loop
				Result [i] := translation (keys [i])
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	translations: EL_SYNCHRONIZED_REF [EL_TRANSLATION_TABLE]
			--
		once ("PROCESS")
			create Result.make (create {EL_TRANSLATION_TABLE}.make_from_file (Translations_file_path))
		end

feature -- Constants

	Date: EL_LOCALE_DATE_ROUTINES
			--
		once
			create Result
		end

	User_language_code: STRING
			--
		once
			Result := implementation.user_language_code
		end

	Translations_file_path: EL_FILE_PATH
			--
		once
			Result := File.joined_path_from_steps (
				Execution.Application_installation_dir, << "localization", "translations.pyx" >>
			)
		end

end
