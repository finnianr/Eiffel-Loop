note
	description: "[
		Updateable set of numbered file resources available in an installation directory
		and a user data directory
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-30 14:48:42 GMT (Friday 30th June 2023)"
	revision: "9"

class
	EL_UPDATEABLE_RESOURCE_SET

inherit
	EL_FILE_MANIFEST_LIST

	EL_MODULE_DIRECTORY

	EL_MODULE_DEFERRED_LOCALE

create
	make, make_for_locale

feature {NONE} -- Initialization

	make (
		a_installed_base_dir, a_updated_base_dir: detachable DIR_PATH
		relative_path: DIR_PATH; extension: READABLE_STRING_GENERAL
	)
		do
			installed_dir := installed_base_dir (a_installed_base_dir) #+ relative_path
			updated_dir := updated_base_dir (a_updated_base_dir) #+ relative_path

			create file_extension.make_from_general (extension)

			if attached first_existing (manifest_location_list) as manifest_path
				and then manifest_path.exists
			then
				make_from_file (manifest_path)
			else
				make_empty
			end
		end

	make_for_locale (
		a_installed_base_dir, a_updated_base_dir: detachable DIR_PATH
		locale_template: ZSTRING; extension: READABLE_STRING_GENERAL
	)
		require
			has_one_substitution: locale_template.occurrences ('%S') = 1
		local
			exists: BOOLEAN; localized_path: DIR_PATH
		do
			across << Locale.language, Locale.default_language >> as lang until exists loop
				localized_path := locale_template #$ [lang.item]
				across
					<< updated_base_dir (a_updated_base_dir), installed_base_dir (a_installed_base_dir) >> as base_dir
				until
					exists
				loop
					exists := base_dir.item.plus_dir (localized_path).exists
				end
			end
			make (a_installed_base_dir, a_updated_base_dir, localized_path, extension)
		end

feature -- Access

	file_extension: ZSTRING

	i_th_path (i: INTEGER): FILE_PATH
		do
			if valid_index (i) then
				Result := new_item_path (i_th (i).name)
			else
				create Result
			end
		end

	installed_dir: DIR_PATH
		-- directory for installed items

	item_path: FILE_PATH
		do
			Result := new_item_path (item.name)
		end

	manifest_name: ZSTRING
		do
			Result := file_extension + "-manifest.xml"
		end

	new_item_path (name: ZSTRING): FILE_PATH
		do
			Result := first_existing (<< updated_dir + name, installed_dir + name >>)
		end

	updated_dir: DIR_PATH
		-- directory for updated items

feature -- Element change

	set_installed_dir (a_installed_dir: like installed_dir)
		do
			installed_dir := a_installed_dir
		end

feature {NONE} -- Implementation

	first_existing (path_list: ITERABLE [FILE_PATH]): FILE_PATH
		local
			exists: BOOLEAN
		do
			across path_list as list until exists loop
				Result := list.item
				exists := Result.exists
			end
		end

	installed_base_dir (base_dir: detachable DIR_PATH): DIR_PATH
		do
			if attached base_dir as dir then
				Result := dir
			else
				Result := Directory.Application_installation
			end
		end

	updated_base_dir (base_dir: detachable DIR_PATH): DIR_PATH
		do
			if attached base_dir as dir then
				Result := dir
			else
				Result := Directory.App_configuration
			end
		end

	manifest_location_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< updated_dir + manifest_name, installed_dir + manifest_name >>)
		end

end