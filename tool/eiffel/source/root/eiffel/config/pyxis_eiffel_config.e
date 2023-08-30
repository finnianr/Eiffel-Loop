note
	description: "Parse basic project information from Eiffel Pyxis configuration file. (Extension: **pecf**)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-28 13:27:36 GMT (Monday 28th August 2023)"
	revision: "9"

class
	PYXIS_EIFFEL_CONFIG

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE

	EL_FILE_OPEN_ROUTINES

create
	make, make_scons

feature {NONE} -- Initialization

	make_scons (scons: SCONS_PROJECT_PY_CONFIG)
		do
			make (scons.pyxis_ecf_path)
			if not scons.build_info_path.is_empty then
				build_info_path := scons.build_info_path
			end
		end

	make (a_pecf_path: FILE_PATH)
		do
			make_default

			ecf_pyxis_path.copy (a_pecf_path)
			source_text := File.plain_text (a_pecf_path)
			create line_intervals.make (source_text, '%N')
			build_from_string (partial_source_text)
		end

	make_default
		do
			Precursor
			build_info_path := Default_build_info_path
			create ecf_pyxis_path
			create source_text.make_empty
			create executable_name.make_empty
			create system.make_default
		end

feature -- Access

	build_info_path: FILE_PATH

	company: ZSTRING
		do
			Result := system.company
		end

	app_cache_path: DIR_PATH
		do
			Result := application_path (Directory.App_cache)
		end

	app_configuration_path: DIR_PATH
		do
			Result := application_path (Directory.App_configuration)
		end

	app_data_path: DIR_PATH
		do
			Result := application_path (Directory.App_data)
		end

	app_installation_path: DIR_PATH
		do
			Result := application_path (Directory.Application_installation)
		end

	ecf_pyxis_path: FILE_PATH

	ecf_xml_path: FILE_PATH
		do
			Result := ecf_pyxis_path.with_new_extension ("ecf")
		end

	product: ZSTRING
		do
			Result := system.product
		end

	system: SYSTEM_VERSION

feature -- Executable

	executable_name: STRING

	executable_name_full: STRING
		do
			if {PLATFORM}.is_windows then
				Result := executable_name + ".exe"
			else
				Result := executable_name
			end
		end

	usr_local_executable_path: FILE_PATH
		do
			Result := "/usr/local/bin/" + executable_name
		end

feature {NONE} -- Implementation

	partial_source_text: STRING
		-- source_text up as far as end of version information
		local
			found: BOOLEAN; s: EL_STRING_8_ROUTINES
		do
			if attached line_intervals as list then
				list.go_i_th (version_element_index + 1)
--				Find end of version information
				from until found or list.after loop
					if attached list.item as item then
						item.adjust
						if s.ends_with_character (item, ':') then
							found := s.is_identifier_boundary (item, 1, item.count - 1)
						end
					end
					if not found then
						list.forth
					end
				end
				if found then
					list.back
					Result := source_text.substring (1, list.item_upper)
				else
					create Result.make_empty
				end
			end
		end

feature -- Basic operations

	bump_build
		-- increase build by one
		do
			if attached system.version as version then
				version.bump_build
				set_version (version)
			end
		end

	set_version (a_version: EL_SOFTWARE_VERSION)
		local
			found: BOOLEAN; tab_count: INTEGER
			item, new_version: STRING
		do
			create item.make_empty
			system.set_version (a_version)

			if attached line_intervals as list then
				list.go_i_th (version_element_index + 1)
--				Find version information line
				from until found or list.after loop
					item := list.item
					if item.occurrences ('=') = 4
						and then across Version_parts as part all item.has_substring (part.item) end
					then
						found := True
					else
						list.forth
					end
				end
				if found then
					tab_count := list.item_leading_occurrences ('%T')
					new_version := a_version.pyxis_attributes
					source_text.replace_substring (new_version, list.item_lower + tab_count, list.item_upper)
					File.write_text (ecf_pyxis_path, source_text)
					write_xml_ecf
					line_intervals.wipe_out
					line_intervals.fill (source_text, '%N', 0)
				end
			end
		ensure
			version_set: system.version ~ a_version
		end

feature {NONE} -- Implementation

	application_path (base_dir: DIR_PATH): DIR_PATH
		local
			steps: EL_PATH_STEPS
		do
			steps := base_dir
			steps.remove_tail (2)
			across << company, product >> as list loop
				steps.extend (list.item)
			end
			Result := steps.to_dir_path
		end

	version_element_index: INTEGER
		do
			if attached line_intervals as list then
				from list.start until Result > 0 or list.after loop
					if list.item_has_substring (Version_element)
						and then source_text [list.item_upper] = ':'
					then
						Result := list.index
					else
						list.forth
					end
				end
			end
		end

	write_xml_ecf
		local
			ecf_generator: ECF_XML_GENERATOR
		do
			if attached open (ecf_pyxis_path.with_new_extension ("ecf"), Write) as ecf_out then
				create ecf_generator.make
				ecf_generator.convert_text (source_text, ecf_out)
				ecf_out.close
			end
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["target/version", agent do set_next_context (system) end],
				["@name", agent do node.set_8 (executable_name) end]
			>>)
		end

feature {NONE} -- Internal attributes

	line_intervals: EL_SPLIT_STRING_8_LIST

	source_text: STRING

feature {NONE} -- Constants

	Default_build_info_path: ZSTRING
		once
			Result := "source/build_info.e"
		end

	Version_parts: EL_STRING_8_LIST
		once
			Result := "major, minor, release, build"
		end

	Root_node_name: STRING = "system"

	Version_element: STRING = "version:"

end