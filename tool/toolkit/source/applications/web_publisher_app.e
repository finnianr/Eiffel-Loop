note
	description: "Summary description for {WEB_PUBLISHER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 19:58:43 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	WEB_PUBLISHER_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_TESTABLE_APPLICATION

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initiliazation

	normal_initialize
			--
		do
			Args.set_string_from_word_option ("config", agent set_config_file_path, Default_config_file_path)
			create config.make (config_file_path)
		end

feature -- Basic operations

	normal_run
			--
		local
			content_dir: EL_DIR_PATH
			find_command: EL_FIND_FILES_COMMAND
			page_list: PART_SORTED_TWO_WAY_LIST [WEB_PAGE]
			page_content_path_list: LIST [EL_FILE_PATH]
		do
			log.enter ("run")
			content_dir := config.web_root_dir.joined_dir_path ("content")
			create find_command.make (content_dir, "*.html")
			find_command.exclude_path_ending (".body.html")
			find_command.execute
			page_content_path_list := find_command.path_list
			create page_list.make
			from page_content_path_list.start until page_content_path_list.after loop
				log_or_io.put_path_field ("CONTENT", page_content_path_list.item)
				log_or_io.put_new_line
				page_list.extend (create {WEB_PAGE}.make (config, page_content_path_list.item))
				page_content_path_list.forth
			end
			from page_list.start until page_list.after loop
				page_list.item.set_menu (page_list)
				page_list.item.publish
				page_list.forth
			end
			log.exit
		end

feature -- Test

	test_run
			--
		do
			Test.do_file_tree_test ("eiffel-loop.com", agent test_eiffel_loop_dot_com, 2753967620)
		end

	test_eiffel_loop_dot_com (directory_path: EL_DIR_PATH)
			--
		do
			log.enter ("test_eiffel_loop_dot_com")
			Default_config_file_path.wipe_out
			Default_config_file_path.append ((directory_path + "config.xml").to_string)

			normal_initialize
			normal_run
			log.exit
		end

feature -- Element change

	set_config_file_path (dir_path: EL_ASTRING)
			--
		do
			config_file_path := dir_path
		end

feature {NONE} -- Implementation: attributes

	config_file_path: EL_FILE_PATH

	config: WEB_PUBLISHER_CONFIG

feature {NONE} -- Constants

	Option_name: STRING = "website_publisher"

	Description: STRING = "Generate web site from Thunderbird html content"

	Default_config_file_path: STRING
			--
		once
			create Result.make_empty
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{WEB_PUBLISHER_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{WEB_PAGE}, "*"],
				[{WEB_PAGE_CONTENT}, "*"],
				[{WEB_PAGE_PROPERTIES}, "*"],
				[{EL_VTD_EXCEPTIONS}, "*"]
			>>
		end

end