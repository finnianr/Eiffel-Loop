note
	description: "Java environment configuration accessible from [$source EL_MODULE_JAVA]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-24 17:03:54 GMT (Thursday 24th March 2022)"
	revision: "12"

class
	JAVA_ENVIRONMENT

inherit
	JAVA_SHARED_ORB

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_ENVIRONMENT

	EL_MODULE_OS

	EL_MODULE_LIO

	EXCEPTION_MANAGER

	MEMORY

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create {JAVA_PLATFORM_IMP} platform.make
			create class_path_list.make_split (new_class_path, platform.class_path_separator)
			class_path_list.prune_all_empty

			create jar_dir_list.make_from_array (<< platform.default_jar_dir >>)
		end

feature -- Element change

	append_class_locations (locations: ARRAY [DIR_PATH])
		do
			across locations as location loop
				if location.item.exists then
					extend_class_path_list (location.item)
				end
			end
		end

	append_jar_locations (locations: ARRAY [DIR_PATH])
			--
		do
			locations.do_all (agent jar_dir_list.extend)
		end

feature -- Status change

	open (java_packages: like required_packages)
			--
		require
			java_installed: is_java_installed
		local
			i: INTEGER
			all_packages_found: BOOLEAN
		do
			required_packages := java_packages
			all_packages_found := true
			across required_packages as package until not all_packages_found loop
				add_package_to_classpath (package.item)
				all_packages_found := all_packages_found and last_package_found
				i := i + 1
			end
			if is_lio_enabled then
				lio.put_line ("CLASSPATH:")
				across class_path_list as class_path loop
					lio.put_line (class_path.item)
				end
			end
			if all_packages_found then
				jorb.open (platform.JVM_library_string_path, class_path_list.joined (platform.class_path_separator))
				is_open := jorb.is_open
			end
		ensure
			is_open: is_open
		end

feature -- Status query

	is_java_installed: BOOLEAN
		-- is Java installed
		do
			Result := platform.JVM_library_path.exists
		end

	is_open: BOOLEAN

	last_package_found: BOOLEAN

feature -- Clean up

	close
			--
		local
			object_references: INTEGER
		do
			if is_lio_enabled then
				lio.put_line ("close")
				lio.put_integer_field ("Object references", jorb.object_count)
				lio.put_new_line
				lio.put_line ("GC collect")
			end
			 -- A `full_collect' can cause a segmentation fault
			full_collect

			object_references := jorb.object_count
			if is_lio_enabled then
				lio.put_integer_field ("Object references remaining", object_references)
				lio.put_new_line
				debug ("jni")
					if object_references > 0 then
						lio.put_line ("Objects still referenced")
						across jorb.referenced_objects as object_id loop
							lio.put_line (jorb.object_names [object_id.item])
						end
					end
				end
			end
			jorb.close_jvm
			is_open := False
			if is_lio_enabled then
				lio.put_line ("JVM removed from memory")
				lio.put_new_line
			end
		ensure
			all_references_deleted: jorb.object_count = 0
		end

feature {NONE} -- Implementation

	add_package_to_classpath (package_name: STRING)
			--
		local
			package_list: EL_FILE_PATH_LIST; jar_file_name: STRING
		do
			create jar_file_name.make_from_string (package_name + "*.jar")
			last_package_found := False
			across jar_dir_list as jar_dir until last_package_found loop
				package_list := OS.file_list (jar_dir.item, jar_file_name)
				if not package_list.is_empty then
					last_package_found := True
					extend_class_path_list (package_list.first_path)
				end
			end
			if not last_package_found then
				lio.put_string_field ("Could not find jars:", jar_file_name)
				lio.put_new_line
			end
		end

	extend_class_path_list (a_location: ZSTRING)
		local
			location: STRING
		do
			location := a_location
			if not class_path_list.has (location) then
				class_path_list.extend (location)
			end
		end

	new_class_path: STRING
		do
			if attached Execution.item ("CLASSPATH") as cp then
				Result := cp
			else
				Result := Empty_string_8
			end
		end

feature {NONE} -- Internal attributes

	class_path_list: EL_STRING_8_LIST

	jar_dir_list: ARRAYED_LIST [DIR_PATH]

	platform: JAVA_PLATFORM_I

	required_packages: ARRAY [STRING]

end