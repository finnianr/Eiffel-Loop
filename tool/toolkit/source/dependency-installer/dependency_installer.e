note
	description: "Summary description for {DEPENDENCY_INSTALLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	DEPENDENCY_INSTALLER

inherit
	EL_FILE_PARSER
		rename
			new_pattern as depends_on_package_pattern
		redefine
			make
		end

	EL_TEXTUAL_PATTERN_FACTORY

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create package_set.make
			package_set.compare_objects
		end

feature -- Basic operations

	install_dependencies
			--
		do
			find_all
			consume_events
			package_set.linear_representation.do_all (agent install_dependency)

			log.put_new_line
			log.put_integer_field ("Packages listed", count)
			log.put_new_line
			log.put_integer_field ("Unique packages count", package_set.count)
			log.put_new_line
		end


feature {NONE} -- Patterns

	depends_on_package_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				string_literal ("Depends: "),
				package_name_pattern |to| agent on_package_name,
				one_of (<<
					white_space_character,
					end_of_line_character
				>>)
			>>)
		end

	package_name_pattern: EL_MATCH_ONE_OR_MORE_TIMES_TP
			--
		do
			Result := one_or_more (
				one_of_characters ( <<
					letter,
					digit,
					one_character_from (".-+")
				>> )
			)
		end

feature {NONE} -- Match actions

	on_package_name (text: EL_STRING_VIEW)
			--
		do
			log.enter ("on_package_name")
			log.put_line (text)
			package_set.extend (text)
			count := count + 1
			log.exit
		end

feature {NONE} -- Implementation

	install_dependency (package_name: STRING)
			--
		do
			log.enter ("install_dependency")
			log.put_line (package_name)
			Reinstall_system_command.set_string (PACKAGE, package_name)
			Reinstall_system_command.execute
			log.exit
		end

	Reinstall_system_command: EL_GENERAL_OS_COMMAND
			--
		once
			create Result.make ("apt-get", "apt-get --yes --reinstall install $PACKAGE")
		end

	PACKAGE: STRING = "PACKAGE"

	package_set: BINARY_SEARCH_TREE_SET [STRING]

	count: INTEGER

end
