note
	description: "[
		This application can save a lot of keyboard typing during Eiffel development. It performs 
		a series shorthand expansions on a single Eiffel class, as well as alphabetically ordering the
		routines in each feature block. It can be usefully incoporated into EiffelStudio using this external
		command template:
			el_toolkit -feature_edit -no_highlighting -source "$file_name"
	]"

	instructions: "See bottom of page"

	

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-02 12:53:56 GMT (Tuesday 2nd August 2016)"
	revision: "2"

class
	EIFFEL_FEATURE_EDITOR_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [EIFFEL_FEATURE_EDITOR_COMMAND]
		redefine
			Option_name
		end

feature -- Testing

	test_run
			-- Passed Jan 2016
		do
--			Test.do_file_test ("Eiffel/feature-edits/job_duration_parser.e", agent test_file_edit, 2770358171)
--			Test.do_file_test ("Eiffel/feature-edits/el_mp3_convert_command.e", agent test_file_edit, 1765953481)
			Test.do_file_test ("Eiffel/feature-edits/el_copy_file_impl.e", agent test_file_edit, 1693063132)
--			Test.do_file_test ("Eiffel/feature-edits/subscription_delivery_email.e", agent test_file_edit, 1599303034)
		end

	test_file_edit (a_source_path: EL_FILE_PATH)
			--
		do
			create command.make (a_source_path)
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [source_path: EL_FILE_PATH]
		do
			create Result
			Result.source_path := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("source", "Source file path")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "feature_edit"

	Description: STRING = "Performs a series of edits and shorthand expansions on an Eiffel class"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_FEATURE_EDITOR_APP}, All_routines],
				[{EIFFEL_FEATURE_EDITOR_COMMAND}, All_routines]
			>>
		end

note
	instructions: "[
		The following is a list expansion rules which the tool recognizes:
		
		**1.** Expands feature block headings using two letter abbeviations for titles as for example:
			@f ec
		becomes:
			feature -- Element change
	
		A list of title codes is defined in class [../../eiffel-dev/class-edit/support/feature_constants.html FEATURE_CONSTANTS].
			
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
				
		**4.** Expands shorthand for intialization arguments as for example:
			make (one:@; two:@; three:@)
				do
				end
		becomes:	
			make (a_one: like one; a_two: like two; a_three: like three)
				do
					one := a_one; two := a_two; three := a_three
				end
					
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
	]"

end
