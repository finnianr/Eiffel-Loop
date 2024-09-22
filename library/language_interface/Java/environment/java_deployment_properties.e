note
	description: "[
		Collection of all deployment.javaws.jre.* properties divided up into versions
			deployment.javaws.jre.<version no>.<key>=<value>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 15:07:19 GMT (Sunday 22nd September 2024)"
	revision: "15"

class
	JAVA_DEPLOYMENT_PROPERTIES

inherit
	ANY

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make_default
		do
			webstart_profiles := << new_properties >>
			plugin_profiles := << new_properties >>
			create profiles.make_assignments (<<
				[Var_javaws, webstart_profiles],
				["javapi", plugin_profiles]
			>>)
		end

	make (file_path: FILE_PATH)
			--
		local
			name_value: EL_NAME_VALUE_PAIR [ZSTRING]
		do
			make_default
			if attached open_lines (file_path, Utf_8) as property_lines then
				across property_lines as line loop
					if not line.shared_item.starts_with_character ('#') and then line.shared_item.has ('=') then
						create name_value.make (line.shared_item, '=')
						import (name_value)
					end
				end
				property_lines.close
			end
		end

feature -- Access

	webstart_profiles: EL_ARRAYED_LIST [like new_properties]
		-- JRE Java web start properties by version

	plugin_profiles: like webstart_profiles
		-- JRE Java web start properties by version

	profiles: EL_ZSTRING_HASH_TABLE [like webstart_profiles]

feature -- Basic operations

	print_to (a_lio: EL_LOGGABLE)
		do
			across profiles as profile loop
				if profile.key ~ Var_javaws then
					a_lio.put_line ("Webstart Profiles")
				else
					a_lio.put_line ("Plugin Profiles")
				end
				a_lio.put_new_line

				across profile.item as l_properties loop
					if not l_properties.item.is_empty then
						a_lio.put_integer_field ("JRE profile", l_properties.cursor_index - 1)
						a_lio.put_new_line
						across l_properties.item.key_list as name loop
							a_lio.put_string_field (name.item, l_properties.item [name.item])
							lio.put_new_line
						end
						lio.put_new_line
					end
				end
			end
			lio.put_new_line
		end

feature {NONE} -- Implementation

	import (nvp: EL_NAME_VALUE_PAIR [ZSTRING])
			--
		local
			key_path_list: EL_ZSTRING_LIST; key, profile_type: ZSTRING
			profile_id, pos_profile_id: INTEGER
		do
			create key_path_list.make_split (nvp.name, '.')
			profile_type := key_path_list.i_th (2)
			if profile_type ~ Var_javaws then
				pos_profile_id := 4
			else
				pos_profile_id := 6
			end
			if key_path_list.count = pos_profile_id + 1
				and then profiles.has_key (profile_type)
				and then key_path_list.i_th (3) ~ Var_jre
				and then key_path_list.i_th (pos_profile_id).is_integer
			then
				key := key_path_list.last
				profile_id := key_path_list.i_th (pos_profile_id).to_integer + 1
				if key ~ Key_path or key ~ Key_location then
					add_property (profiles [profile_type], key, nvp.value.unescaped (Escaped_characters), profile_id)
				else
					add_property (profiles [profile_type], key, nvp.value, profile_id)
				end
			end
		end

	add_property (a_profile: like webstart_profiles; key, value: ZSTRING; version: INTEGER)
		do
			if is_lio_enabled then
				lio.put_labeled_substitution ("add_property", " (%"%S%", %"%S%", %S)", [key, value, version])
				lio.put_new_line
			end
			if version > a_profile.count then
				from until version = a_profile.count loop
					a_profile.extend (new_properties)
				end
			end
			a_profile.i_th (version).put (value, key)
			if is_lio_enabled then
				lio.put_new_line
			end
		end

	new_properties: EL_ZSTRING_HASH_TABLE [ZSTRING]
		do
			create Result.make_equal (7)
		end

feature {NONE} -- Constants

	Var_javaws: ZSTRING
		once
			Result := "javaws"
		end

	Var_jre: ZSTRING
		once
			Result := "jre"
		end

	Key_path: ZSTRING
		once
			Result := "path"
		end

	Key_location: ZSTRING
		once
			Result := "location"
		end

	Escaped_characters: EL_ZSTRING_UNESCAPER
		local
			table: EL_ESCAPE_TABLE
		once
			create table.make ('\', "::=:")
			create Result.make (table)
		end

end