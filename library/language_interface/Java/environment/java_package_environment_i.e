note
	description: "Java package environment i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	JAVA_PACKAGE_ENVIRONMENT_I

inherit
	JAVA_SHARED_ORB

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_ENVIRONMENT

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EXCEPTION_MANAGER

	MEMORY

feature {NONE} -- Initialization

	make
			--
		do
			if attached {STRING_32} Execution.item ("CLASSPATH") as environment_class_path then
				create class_path_list.make_with_separator (environment_class_path, class_path_separator, False)
			else
				create class_path_list.make_empty
			end
			class_path_list.compare_objects
			create jar_dir_list.make_from_array (<< default_java_jar_dir >>)
			if (not JVM_library_path.is_empty) and then JVM_library_path.exists then
				is_java_installed := True
			end
		end

feature -- Element change

	append_jar_locations (locations: ARRAY [EL_DIR_PATH])
			--
		do
			locations.do_all (agent jar_dir_list.extend)
		end

	append_class_locations (locations: ARRAY [EL_DIR_PATH])
		do
			across locations as location loop
				if location.item.exists then
					extend_class_path_list (location.item)
				end
			end
		end

feature -- Status change

	open (java_packages: like required_java_packages)
			--
		require
			java_installed: is_java_installed
		local
			i: INTEGER
			all_packages_found: BOOLEAN
		do
			required_java_packages := java_packages
			all_packages_found := true
			from i := 1 until not all_packages_found or i > required_java_packages.count loop
				add_package_to_classpath (required_java_packages [i])
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
				jorb.open (JVM_library_path.to_string.to_latin_1, class_path_list.joined (class_path_separator))
				is_open := jorb.is_open
			end
		ensure
			is_open: is_open
		end

feature -- Status query

	is_open: BOOLEAN

	is_java_installed: BOOLEAN
		-- is Java installed

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
				lio.put_line ("Full collect")
			end
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

feature {NONE} -- Platform implementation

	default_java_jar_dir: EL_DIR_PATH
		deferred
		end

	JVM_library_path: EL_FILE_PATH
		deferred
		end

	class_path_separator: CHARACTER
		deferred
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
				create package_list.make (jar_dir.item, jar_file_name)
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

	extend_class_path_list (location: ZSTRING)
		do
			class_path_list.start
			class_path_list.search (location)
			if class_path_list.exhausted then
				class_path_list.extend (location)
			end
		end

	required_java_packages: ARRAY [STRING]

	jar_dir_list: ARRAYED_LIST [EL_DIR_PATH]

	class_path_list: EL_ZSTRING_LIST

end