note
	description: "Summary description for {WEB_PUBLISHER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 20:14:22 GMT (Friday 8th July 2016)"
	revision: "1"

class
	WEB_PUBLISHER_APP

inherit
	EL_SUB_APPLICATION
		undefine
			new_lio, new_log_manager
		redefine
			Option_name
		end

	EL_REGRESSION_TESTING_APPLICATION

	EL_MODULE_COMMAND
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
			find_cmd: like Command.new_find_files
			page_list: PART_SORTED_TWO_WAY_LIST [WEB_PAGE]
			page_content_path_list: LIST [EL_FILE_PATH]
		do
			log.enter ("run")
			content_dir := config.web_root_dir.joined_dir_path ("content")
			find_cmd := Command.new_find_files (content_dir, "*.html")
			find_cmd.set_not_path_included_condition (agent is_body_html)
			find_cmd.execute
			page_content_path_list := find_cmd.path_list
			create page_list.make
			from page_content_path_list.start until page_content_path_list.after loop
				lio.put_path_field ("CONTENT", page_content_path_list.item)
				lio.put_new_line
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

	set_config_file_path (dir_path: ZSTRING)
			--
		do
			config_file_path := dir_path
		end

feature {NONE} -- Implementation

	is_body_html (path: ZSTRING): BOOLEAN
		do
			Result := path.ends_with_general (".body.html")
		end

feature {NONE} -- Internal attributes

	config_file_path: EL_FILE_PATH

	config: WEB_PUBLISHER_CONFIG

feature {NONE} -- Constants

	Option_name: STRING = "website_publisher"

	Description: STRING = "Generate web site from Thunderbird html content"

	Default_config_file_path: ZSTRING
			--
		once
			create Result.make_empty
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{WEB_PUBLISHER_APP}, All_routines]
			>>
		end

end