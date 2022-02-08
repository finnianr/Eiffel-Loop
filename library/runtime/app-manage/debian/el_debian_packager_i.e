note
	description: "[
		Command that will create a Debian install package for current application based on a root class
		that inherits [$source EL_MULTI_APPLICATION_ROOT].
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 10:33:00 GMT (Tuesday 8th February 2022)"
	revision: "21"

deferred class
	EL_DEBIAN_PACKAGER_I

inherit
	EL_APPLICATION_COMMAND

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_FILE_OPEN_ROUTINES

	EL_SHARED_APPLICATION_LIST

	EL_DEBIAN_CONSTANTS

	EL_MODULE_BUILD_INFO; EL_MODULE_DIRECTORY; EL_MODULE_EXECUTABLE; EL_MODULE_LIO
	EL_MODULE_OS; EL_MODULE_FILE

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

	EL_ZSTRING_CONSTANTS

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_debian_dir, a_output_dir, a_package_dir: DIR_PATH)
		do
			debian_dir := a_debian_dir; output_dir := a_output_dir; package_dir := a_package_dir
			make_machine
			create package.make_empty

			create configuration_file_list.make_empty
			do_once_with_file_lines (agent find_package, open_lines (debian_dir + Control, Utf_8))
			versioned_package := package_name_parts.joined ('-')
			versioned_package_dir := Directory.temporary.joined_dir_tuple ([versioned_package])
		end

feature -- Constants

	Description: STRING = "Create a Debian package in output directory for this application"

feature -- Basic operations

	execute
		local
			script: EL_DEBIAN_MAKE_SCRIPT
		do
			put_opt_contents; put_xdg_entries; put_debian_files

			-- needed to prevent erroneous error message "line too long in conffiles"
			configuration_file_list.extend (Empty_string)
			if attached open (versioned_package_dir.joined_file_tuple ([Debian, Conffiles]), Write) as l_file then
				l_file.put_lines (configuration_file_list)
				l_file.close
			end
			create script.make (Current)
			script.execute

			if script.has_error then
				lio.put_line ("Package not created")
			else
				OS.move_file (package_file_path, output_dir)
			end
		end

feature {EL_DEBIAN_MAKE_SCRIPT} -- Implementation

	executables_list: EL_FILE_PATH_LIST
		do
			create Result.make_empty
			across OS.file_list (versioned_package_dir, All_files).query_if (agent is_executable) as path loop
				Result.extend (path.item.relative_path (Directory.temporary))
			end
		end

	installed_size: NATURAL
		do
			Result := OS.find_files_command (package_dir, All_files).sum_file_byte_count
		end

	is_executable (path: FILE_PATH): BOOLEAN
		local
			dir_name: ZSTRING
		do
			dir_name := path.parent.base
			if dir_name ~ Bin and then (path.has_extension (Bash_extension) or else path.base ~ Executable.name) then
				Result := True
			elseif dir_name ~ Debian and then File.line_one (path).starts_with (once "#!/bin") then
				Result := True
			end
		end

	package_file_path: FILE_PATH
		do
			Result := versioned_package_dir.to_string
			Result.add_extension ("deb")
		end

	package_name_parts: EL_ZSTRING_LIST
		do
			create Result.make_from_array (<< package, architecture, Build_info.version.string >>)
		end

	package_sub_dir (absolute_dir: DIR_PATH): DIR_PATH
		require
			is_absolute: absolute_dir.is_absolute
		do
			Result := versioned_package_dir.joined_dir_path (absolute_dir.relative_path (Root_dir))
		end

	put_debian_files
		-- copy control file and any installer scripts
		local
			control_file: EL_DEBIAN_CONTROL; destination_path: FILE_PATH
		do
			across Shared_directory.named (debian_dir).files as file_path loop
				destination_path := versioned_package_dir.joined_file_tuple ([Debian, file_path.item.base])
				if file_path.item.base ~ Control then
					create control_file.make (file_path.item, destination_path)
					control_file.set_installed_size (installed_size)
					control_file.serialize
				elseif file_path.item.extension /~ Evc_extension then
					OS.copy_file (file_path.item, destination_path)
				end
			end
		end

	put_opt_contents
		local
			destination_dir: DIR_PATH
		do
			destination_dir := package_sub_dir (Directory.Application_installation)

			OS.File_system.make_directory (destination_dir)
			OS.find_directories_command (package_dir).copy_sub_directories (destination_dir)
			OS.find_files_command (package_dir, All_files).copy_directory_files (destination_dir)
		end

	put_xdg_entries
		-- Write XDG desktop entries on Unix
		-- Do nothing on Windows
		deferred
		end

feature {NONE} -- Line states

	find_architecture (line: ZSTRING)
		local
			f: EL_COLON_FIELD_ROUTINES
		do
			if f.name (line) ~ Field.architecture then
				architecture := f.value (line)
				state := final
			end
		end

	find_package (line: ZSTRING)
		local
			f: EL_COLON_FIELD_ROUTINES
		do
			if f.name (line) ~ Field.package then
				package := f.value (line)
				state := agent find_architecture
			end
		end

feature {EL_DEBIAN_MAKE_SCRIPT} -- Internal attributes

	architecture: ZSTRING

	configuration_file_list: EL_ZSTRING_LIST

	debian_dir: DIR_PATH
		-- directory with Control template and scripts

	output_dir: DIR_PATH

	package: ZSTRING
		-- package name

	package_dir: DIR_PATH

	versioned_package: ZSTRING
		-- package name with appended version

	versioned_package_dir: DIR_PATH

feature {NONE} -- Constants

	All_files: STRING = "*"

	Bash_extension: ZSTRING
		once
			Result := "sh"
		end

	Evc_extension: ZSTRING
		-- Compiled Evolicity extension
		once
			Result := "evc"
		end

	Root_dir: DIR_PATH
		once
			Result := "/"
		end

note
	notes: "[
		**Platform Implementation**

		As the application may also need to compile on Windows, class [$source EL_DEBIAN_PACKAGER_IMP] isolates
		functions that are specific to Unix, specifically the creation of XDG desktop entries. See routine `put_xdg_entries'.

		**Sub Application**

		By including [$source EL_DEBIAN_PACKAGER_APP] in the list of sub-application types listed in the root
		class implementing [$source EL_MULTI_APPLICATION_ROOT], the application becomes capable of generating
		it's own install package. At least one sub-application must conform to [$source EL_INSTALLABLE_APPLICATION].

		A script to set permissions and ownership is generated and executed. It will prompt for the sudo password.

		**Production Example**

		This class has been used to create a Debian package for the
		[http://myching.software/en/download/latest-version.html My Ching application].
		
		**Version Number Origin**
		
		The version number is picked up from the generated file BUILD_INFO which is generated by the Eiffel-Loop
		Scons build system and placed in the project source directory. This class is globally available from the class
		[$source EL_MODULE_BUILD_INFO]
		
		The build system obtains the version number from the project ECF file. (shown here in Pyxis format)
		
			target: 
				name = classic

				root:
					class = APPLICATION_ROOT; feature = make
				version:
					major = 1; minor = 0; release = 31; build = 1550
					company = "Hex 11 Software"; product = "My Ching"
					copyright = "Finnian Reilly"
					
		**Install Location**
		
		The `dpkg' install command will install the application in a directory derived from the
		`company' and `product' found in the ECF version information. A typical install will look
		like the following:
		
			/opt/$company/$product/bin
			/opt/$company/$product/config
			/opt/$company/$product/desktop-icons
			/opt/$company/$product/icons
			/opt/$company/$product/locales

	]"
	instructions: "[
		**DEBIAN DIRECTORY**
		
		Create a sub-directory `DEBIAN' in your project directory containing the Debian control file and
		installer scripts, as for example:
		
			DEBIAN
			DEBIAN/control
			DEBIAN/control.evc
			DEBIAN/copyright
			DEBIAN/postinst
			DEBIAN/preinst
			DEBIAN/prerm
			
		Note that the control file is a template containing the substitution variables `$version' and `$installed_size'.
		These variables are substituted during package generation. The file `control.evc' is an automatically generated
		file related to the compilation of the *control* file by the Evolicity compiler.
		
		Creating all of these files (except control.evc) is the responsibility of the developer. They are actually
		pretty simple to create by following a [https://ubuntuforums.org/showthread.php?t=910717 basic tutorial]
		on creating Debian packages, or just by studying the thousands of available examples.
		
		**Output**
		
		By default running the sub-application [$source EL_DEBIAN_PACKAGER_APP] will generate the package
		for the current project application in the directory:
		
			build/$ISE_PLATFORM
			
		For example if the project directory is `My Ching' and the package is named `myching' in the control file,
		you will get this output for version 1.0.31.
		
			My Ching/build/linux-x86-64/myching-amd64-1.0.31.deb
	]"

end