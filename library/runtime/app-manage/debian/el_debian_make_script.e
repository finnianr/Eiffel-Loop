note
	description: "Script to create Debian package after adjusting file permissions and ownership"
	notes: "[
		Example of generated script:

			sudo chown -R root:root MyChing-1.0.30

			# set file permissions: 644  -rw-r--r--
			sudo find MyChing-1.0.30 -type f -print -exec chmod 644 {} \;

			#set permissions: 755 -rwxr-xr-x
			sudo chmod 755 MyChing-1.0.30/opt/Hex\ 11\ Software/My\ Ching/bin/myching.sh
			sudo chmod 755 MyChing-1.0.30/opt/Hex\ 11\ Software/My\ Ching/bin/myching
			sudo chmod 755 MyChing-1.0.30/DEBIAN/prerm
			sudo chmod 755 MyChing-1.0.30/DEBIAN/postinst

			sudo dpkg-deb --build MyChing-1.0.30

			sudo rm -r MyChing-1.0.30

			sudo chown finnian:finnian MyChing-1.0.30.deb
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 9:58:04 GMT (Tuesday 8th February 2022)"
	revision: "6"

class
	EL_DEBIAN_MAKE_SCRIPT

inherit
	EL_COMMAND

	EVOLICITY_SERIALIZEABLE
		export
			{NONE} all
		end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_OS; EL_MODULE_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make (a_packager: EL_DEBIAN_PACKAGER_I)
		do
			packager := a_packager
			make_from_file (Directory.temporary + "make_debian_package.sh")
		end

feature -- Basic operations

	execute
		local
			command: EL_OS_COMMAND
		do
			serialize
			File.add_permission (output_path, "u", "x")
			create command.make (Dot_slash + output_path.base)
			command.set_working_directory (output_path.parent)
			command.execute
			has_error := command.has_error
			OS.delete_file (output_path)
		end

feature -- Status query

	has_error: BOOLEAN

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["executables_list", agent: LIST [ZSTRING] do Result := packager.executables_list.as_escaped end],
				["package_name", agent: ZSTRING do Result := packager.versioned_package end],
				["user_name", agent: ZSTRING do Result := Environment.Operating.user_name end]
			>>)
		end

feature {NONE} -- Internal attributes

	packager: EL_DEBIAN_PACKAGER_I

feature {NONE} -- Constants

	Dot_slash: ZSTRING
		once
			Result := "./"
		end

	Template: STRING = "[
		sudo chown -R root:root $package_name

		# set file permissions: 644  -rw-r--r--
		sudo find $package_name -type f -print -exec chmod 644 {} \;

		# set execute permissions: 755 -rwxr-xr-x
		#across $executables_list as $path loop
		sudo chmod 755 $path.item
		#end
		sudo dpkg-deb --build $package_name 2>&1
		status=$?
		sudo rm -r $package_name
		if [ $$status -ne 0 ]; then
			echo "Error building $package_name.deb"
			exit $$status
		else
			sudo chown $user_name:$user_name ${package_name}.deb
		fi
	]"
end