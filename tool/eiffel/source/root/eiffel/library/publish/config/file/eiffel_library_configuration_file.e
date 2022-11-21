note
	description: "Eiffel library configuration file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 10:51:49 GMT (Monday 21st November 2022)"
	revision: "12"

class
	EIFFEL_LIBRARY_CONFIGURATION_FILE

inherit
	EIFFEL_CONFIGURATION_FILE
		redefine
			category_index_title, new_class, new_sub_category, new_sort_category, type
		end

	EL_ZSTRING_CONSTANTS

create
	make

feature -- Access

	category_index_title: ZSTRING
		-- Category title for sitemap index
		do
			Result := Category_title_template #$ [Precursor, sub_category]
		end

	type: STRING
		do
			Result := once "library" + type_qualifier
		end

feature {EIFFEL_CLASS_PARSER} -- Factory

	new_class (source_path: FILE_PATH): EIFFEL_LIBRARY_CLASS
		do
			create Result.make (source_path, Current, repository)
		end

	new_sort_category: ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := category + s.character_string (' ') + sub_category
		end

	new_sub_category: ZSTRING
		local
			words: EL_ZSTRING_LIST; relative_steps: EL_PATH_STEPS
		do
			if dir_path.is_empty then
				create Result.make_empty
			else
				relative_steps := dir_path.relative_path (repository.root_dir)
				if relative_steps.count >= 2 then
					create words.make_split (relative_steps [2], '_')
					Result := words.joined_propercase_words
				else
					create Result.make_empty
				end
			end
		end

feature {NONE} -- Constants

	Category_title_template: ZSTRING
		once
			Result := "%S (%S)"
		end

end