note
	description: "[
		Collection of all deployment.javaws.jre.* properties divided up into versions
			deployment.javaws.jre.<version no>.<key>=<value>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-09 6:59:36 GMT (Saturday 9th July 2016)"
	revision: "7"

class
	JAVA_DEPLOYMENT_PROPERTIES

inherit
	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make_default
		do
			create webstart_profiles.make_from_array (<< new_properties >>)
			create plugin_profiles.make_from_array (<< new_properties >>)
			create profiles.make (<<
				[Var_javaws, webstart_profiles],
				["javapi", plugin_profiles]
			>>)
		end

	make (file_path: EL_FILE_PATH)
			--
		local
			property_lines: EL_FILE_LINE_SOURCE
		do
			make_default
			create property_lines.make (file_path)
			across property_lines as line loop
				if not (line.item.is_empty or else line.item.starts_with (Hash_sign)) then
					import_line (line.item)
				end
			end
		end

feature -- Access

	webstart_profiles: ARRAYED_LIST [like new_properties]
		-- JRE Java web start properties by version

	plugin_profiles: like webstart_profiles
		-- JRE Java web start properties by version


	profiles: EL_ZSTRING_HASH_TABLE [like webstart_profiles]

feature -- Basic operations

	dump
		do
			lio.put_line ("dump")
			across profiles as profile loop
				if profile.key ~ Var_javaws then
					lio.put_line ("Webstart Profiles")
				else
					lio.put_line ("Plugin Profiles")
				end
				lio.put_new_line

				across profile.item as l_properties loop
					if not l_properties.item.is_empty then
						lio.put_integer_field ("JRE profile", l_properties.cursor_index - 1)
						lio.put_new_line
						across l_properties.item.current_keys as name loop
							lio.put_string_field (name.item, l_properties.item [name.item])
							lio.put_new_line
						end
						lio.put_new_line
					end
				end
			end
			lio.put_new_line
		end

feature {NONE} -- Implementation

	import_line (line: ZSTRING)
			--
		local
			key_path_list: EL_ZSTRING_LIST
			key, value, profile_type: ZSTRING
			profile_id, pos_equal_sign, pos_profile_id: INTEGER
		do
			pos_equal_sign := line.index_of ('=', 1)
			create key_path_list.make_with_separator (line.substring (1, pos_equal_sign - 1), '.', False)
			value := line.substring (pos_equal_sign + 1, line.count)
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
					add_property (profiles [profile_type], key, value.unescaped (Escaped_characters), profile_id)
				else
					add_property (profiles [profile_type], key, value, profile_id)
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

	Hash_sign: ZSTRING
		once
			Result := "#"
		end

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

	Escaped_characters: EL_ESCAPE_TABLE
		local
			table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create table.make (3); table [':'] := ':'
			create Result.make ('\', table)
		end

end
