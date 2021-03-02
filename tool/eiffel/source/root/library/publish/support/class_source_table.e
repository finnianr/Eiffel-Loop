note
	description: "Map class name to HTML source path"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 17:00:42 GMT (Tuesday 2nd March 2021)"
	revision: "2"

class
	CLASS_SOURCE_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [EL_FILE_PATH]
		rename
			make as table_make
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_MODULE_COMMAND

	PUBLISHER_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_ise_chart_template: ZSTRING)
		require
			enough_holders: a_ise_chart_template.occurrences ('%S') = 2
		do
			make_solitary
			ise_chart_template := a_ise_chart_template
			ise_library_path := "$ISE_EIFFEL/library"
			ise_library_path.expand
			make_equal (1000)
			create last_name.make_empty
		end

feature -- Access

	last_name: ZSTRING

feature -- Element change

	put_class (e_class: EIFFEL_CLASS)
		do
			put (e_class.relative_source_path.with_new_extension (Html), e_class.name)
		end

feature -- Status query

	has_class (text: ZSTRING): BOOLEAN
		local
			pos_bracket: INTEGER; leading, file_name: ZSTRING
			find_ise_class: EL_FIND_FILES_COMMAND_I
			path_steps: EL_PATH_STEPS
		do
			pos_bracket := text.index_of ('[', 1)
			if text.is_empty then
				last_name.wipe_out

			elseif pos_bracket > 0 then
				-- remove class parameter
				leading := text.substring (1, pos_bracket - 1)
				leading.right_adjust
				last_name := class_name (leading)
				Result := has_key (last_name)
			else
				last_name := class_name (text)
				Result := has_key (last_name)
			end
			if not Result and then not text.is_empty then
				file_name := last_name.as_lower + Dot_e
				find_ise_class := Command.new_find_files (ise_library_path, file_name)
				find_ise_class.execute
				if find_ise_class.path_list.count > 0 then
					path_steps := find_ise_class.path_list.first.relative_path (ise_library_path)
					found_item := ise_chart_template #$ [path_steps.first, last_name.as_lower]
					Result := True
				end
			end
		end

feature {NONE} -- Implementation

	class_name (text: ZSTRING): ZSTRING
		local
			done, alpha_found: BOOLEAN
		do
			if text.item (1).is_alpha then
				Result := text
			else
				create Result.make (text.count - 2)
				across text as c until done loop
					if alpha_found then
						inspect c.item
							when '_', 'A' .. 'Z' then
								Result.append_character (c.item)
						else
							done := True
						end
					elseif c.item.is_alpha then
						alpha_found := True
						Result.append_character (c.item)
					end
				end
			end
		end

feature {NONE} -- Initialization

	ise_chart_template: ZSTRING

	ise_library_path: EL_DIR_PATH

feature {NONE} -- Constants

	Dot_e: ZSTRING
		once
			Result := ".e"
		end

end