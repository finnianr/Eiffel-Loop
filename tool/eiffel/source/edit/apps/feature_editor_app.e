note
	description: "[
		Command line interface to command ${FEATURE_EDITOR_COMMAND} for use as an EiffelStudio external tool
	]"
	notes: "[
		This application can save a lot of unnecessary keyboard typing during Eiffel development. It performs 
		a series of expansions on shorthand expressions present in a single Eiffel class. In addition to performing
		expansions, it also alphabetically orders the routines in each feature block. It can be usefully incoporated
		into EiffelStudio using the external tools manager.

		**USAGE**
			el_eiffel -feature_editor -no_highlighting -source <path to Eiffel source>
	]"
	instructions: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-07 14:22:08 GMT (Wednesday 7th May 2025)"
	revision: "26"

class
	FEATURE_EDITOR_APP

inherit
	EL_COMMAND_LINE_APPLICATION [FEATURE_EDITOR_COMMAND]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("source", "Source file path", << file_must_exist >>),
				optional_argument ("dry_run", "Print output to screen without modifying file", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, False)
		end

note
	instructions: "[
		To use it, enter some shorthand  in an Eiffel class (described below).
		Save the source file, and then invoke the `-feature_editor' command switch. EiffelStudio
		automatically reloads the modified class. You can then carry on editing.

		The following is a list expansion rules which the tool recognizes:
		
		**1.** Expands feature block headings using two letter abbeviations for titles as for example:
			@f ec
		becomes:
			feature -- Element change
	
		A list of title codes is defined in class ${FEATURE_CONSTANTS}.
			
		**2.** Similar to 1 but for unexported feature blocks as for example:
			@f {ia
		becomes:
			feature {NONE} -- Internal attributes
		
		**3.** Expands attribute setting procedures as for example:
			@set name
		becomes:
			set_name (a_name: like name)
				do
					name := a_name
				end
				
		If the type of `name' is known, the explicit type name is used instead of the anchored name.
				
		**4.** Expands shorthand for intialization arguments as for example:
			make (one:@; two:@; three:@)
				do
				end
		becomes:	
			make (a_one: like one; a_two: like two; a_three: like three)
				do
					one := a_one; two := a_two; three := a_three
				end
				
		If the type of any argument is known, the explicit type name is used instead of the anchored name.
					
		**5.** Expands shorthand form of incremented variable iteration as for example:
			@from j > n
		becomes:
			from j := 1 until j > n loop
				j := j + 1
			end
				
		**6.** Expands forwards list iteration shorthand as for example: 
			@from list.after
		becomes:
			from list.start until list.after loop
				list.forth
			end
				
		**7.** Expands backwards list iteration shorthand as for example:
			@from list.before
		becomes:
			from list.finish until list.before loop
				list.back
			end
				
		**8.** Reorders alphabetically the features in each feature block

		**9.** Aligns right column entries in array tuples used to initialize tables as for example:

			make
				-- initialize `test_table'
				do
					make_named (<<
						["adjusted_immutable_string",	agent test_adjusted_immutable_string],
						["bracketed",						agent test_bracketed],
						["delimited_list",				agent test_delimited_list],
						["immutable_string_manager",	agent test_immutable_string_manager]
					>>)
				end

	]"

end