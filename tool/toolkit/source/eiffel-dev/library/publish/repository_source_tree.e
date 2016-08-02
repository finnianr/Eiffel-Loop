note
	description: "Eiffel repository source tree"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-26 15:13:00 GMT (Tuesday 26th July 2016)"
	revision: "1"

class
	REPOSITORY_SOURCE_TREE

inherit
	EIFFEL_SOURCE_TREE
		redefine
			getter_function_table, building_action_table, make_default,
			on_context_exit
		end

	EL_MODULE_LOG
		undefine
			is_equal
		end

create
	make, make_with_name

feature {NONE} -- Initialization

	make (a_repository: like repository)
			--
		do
			make_default
			repository := a_repository
		end

	make_default
		do
			create directory_list.make_empty
			create description_lines.make_empty
			create ecf_name.make_empty
			Precursor
		end

	make_with_name (a_repository: like repository; a_name: like name; a_dir_path: like dir_path)
		do
			make (a_repository)
			name := a_name; dir_path := a_dir_path
		end

feature -- Access

	description_lines: EL_ZSTRING_LIST

	directory_list: EL_ARRAYED_LIST [EIFFEL_SOURCE_DIRECTORY]

	ecf_name: ZSTRING

	github_description: ZSTRING
		-- Eiffel-View markdown translated to Github markdown
		do
			create Result.make (description_lines.character_count)
			across description_lines as line loop
				if not Result.is_empty then
					if line.item.is_empty then
						Result.append_string_general (Double_new_line)
					elseif line.item.starts_with (Bullet_point) then
						Result.append_character ('%N')
					elseif not Result.ends_with (Double_new_line) then
						Result.append_character (' ')
					end
				end
				Result.append (line.item)
			end
			replace_links (Result); replace_apostrophes (Result)
			Result.replace_substring_general_all ("''", "*")
		end

feature -- Element change

	set_description_lines (a_description: ZSTRING)
		do
			create description_lines.make_with_lines (a_description)
		end

feature -- Basic operations

	read_source_files
		local
			parent_dir: EL_DIR_PATH; source_directory: EIFFEL_SOURCE_DIRECTORY
			class_list: like directory_list.item.class_list; relative_html_path: EL_FILE_PATH
			eiffel_class: EIFFEL_CLASS
		do
			lio.put_path_field ("Eiffel", dir_path)
			lio.put_new_line
			create parent_dir
			directory_list.wipe_out
			across sorted_path_list as path loop
				if path.item.parent /~ parent_dir then
					create class_list.make (10)
					create source_directory.make (dir_path, class_list, directory_list.count + 1)
					directory_list.extend (source_directory)
					parent_dir := path.item.parent
				end
				lio.put_character ('.')
				if path.cursor_index \\ 80 = 0 or else path.cursor_index = path_list.count then
					lio.put_new_line
				end
				relative_html_path := path.item.relative_path (dir_path).with_new_extension ("html")
				if path.item.relative_path (repository.root_dir).first_step ~ Library then
					create {LIBRARY_EIFFEL_CLASS} eiffel_class.make (path.item, relative_html_path, repository)
				else
					create eiffel_class.make (path.item, relative_html_path, repository)
					repository.example_classes.extend (eiffel_class)
				end
				source_directory.class_list.extend (eiffel_class)
			end
		end

feature {NONE} -- Implementation

	new_description_lines (file_path: EL_FILE_PATH): like description_lines
		local
			file_lines: EL_FILE_LINE_SOURCE
		do
			create Result.make (10)
			create file_lines.make (file_path)
			file_lines.do_all (agent Result.extend)
		end

	replace_apostrophes (text: ZSTRING)
			-- change (`xx') to (`xx`) in order be compatible with Github markdown
		local
			pos_grave, pos_apostrophe: INTEGER; done: BOOLEAN
		do
			from done := False until done or pos_grave > text.count loop
				pos_grave := text.index_of ('`', pos_grave + 1)
				if pos_grave > 0 then
					pos_apostrophe := text.index_of ('%'', pos_grave + 1)
					if pos_apostrophe > 0 then
						text.put ('`', pos_apostrophe)
						pos_grave := pos_apostrophe
					end
				else
					done := True
				end
			end
		end

	replace_links (text: ZSTRING)
			-- change [http://address.com click here] to [click here](http://address.com)
			-- in order to be compatible with Github markdown
		local
			pos_link, pos_space, pos_right_bracket: INTEGER; done: BOOLEAN
			link_address: ZSTRING
		do
			across Http_links as http loop
				from done := False until done loop
					pos_link := text.substring_index (http.item, pos_link + 1)
					if pos_link > 0 then
						pos_space := text.index_of (' ', pos_link + 1)
						if pos_space > 0 then
							link_address := text.substring (pos_link + 1, pos_space - 1)
							if link_address [1] = '.' then
								link_address.replace_substring (repository.web_address, 1, 1)
							end
							text.remove_substring (pos_link + 1, pos_space)
							pos_right_bracket := text.index_of (']', pos_link + 1)
							if pos_right_bracket > 0 then
								text.insert_string (link_address.enclosed ('(', ')'), pos_right_bracket + 1)
								pos_link := pos_right_bracket + link_address.count + 2
							end
						end
					else
						done := True
					end
				end
			end
		end

	repository: EIFFEL_REPOSITORY_PUBLISHER

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["directory_list",		agent: like directory_list do Result := directory_list end],
				["has_description",		agent: BOOLEAN_REF do Result := (not description_lines.is_empty).to_reference end],
				["github_description",	agent github_description]
			>>)
		end

feature {NONE} -- Build from Pyxis

	on_context_exit
		local
			emd_path: EL_FILE_PATH
		do
			if description_lines.is_empty then
				emd_path := repository.file_path.parent + (dir_path.base + Dot_emd_extension)
				if emd_path.exists then
					description_lines := new_description_lines (emd_path)
				end
			end
		end

	set_description_from_node
		local
			text: ZSTRING
		do
			text := node.to_string
			if not text.has ('%N') and then text.ends_with (Dot_emd_extension)
				and then (repository.file_path.parent + text).exists
			then
				description_lines := new_description_lines (repository.file_path.parent + text)
			else
				create description_lines.make_with_lines (text)
			end
		end

	set_dir_path_from_node
		do
			dir_path := repository.root_dir.joined_dir_path (node.to_string)
		end

	building_action_table: like Type_building_actions
		do
			Result := Precursor
			Result.append_tuples (<<
				["@dir",						agent set_dir_path_from_node],
				["@ecf",						agent do ecf_name := node.to_string end],
				["description/text()",	agent set_description_from_node]
			>>)
		end

feature {NONE} -- Constants

	Dot_emd_extension: ZSTRING
		once
			Result := ".emd"
		end

	Double_new_line: ZSTRING
		once
			Result := "%N%N"
		end

	Bullet_point: ZSTRING
		once
			Result := "* "
		end

	Http_links: ARRAY [ZSTRING]
		once
			Result := << "[http://", "[https://", "[./" >>
		end

	Library: ZSTRING
		once
			Result := "library"
		end

end
