note
	description: "[
		Top level class for Evolicity accessible though EL_MODULE_EVOLICITY_TEMPLATES
	
		The templating substitution language was named "Evolicity" as a portmanteau of "Evolve" and "Felicity" 
		which is also a partial anagram of "Velocity" the Apache project which inspired it. 
		It also bows to an established tradition of naming Eiffel orientated projects starting with the letter 'E'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-18 11:00:45 GMT (Monday 18th January 2016)"
	revision: "6"

class
	EVOLICITY_TEMPLATES

inherit
	EL_MODULE_LOG
		redefine
			default_create
		end

	EL_THREAD_ACCESS
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			create table.make_equal (19)
			set_nice_indentation
			create text_encoding.make_utf_8
		end

feature -- Access

	text_encoding: EL_ENCODEABLE_AS_TEXT

feature -- Element change

	set_text_encoding (a_text_encoding: like text_encoding)
		do
			text_encoding := a_text_encoding
		end

	set_encoding_utf_8
		do
			create text_encoding.make_utf_8
		end

	set_encoding_latin_1
		do
			create text_encoding.make_latin_1
		end

feature -- Status query

	is_nested_output_indented: BOOLEAN
		-- is the indenting feature that nicely indents nested XML, active?
		-- Active by default.

	has (a_name: EL_FILE_PATH): BOOLEAN
		local
			compiler_table: like Compilers.item
 		do
			restrict_access (Compilers)
				compiler_table := Compilers.item
				Result := compiler_table.has (a_name)
			end_restriction (Compilers)
		end

feature -- Status change

	set_horrible_indentation
			-- Turn off the indenting feature that nicely indents nested XML
			-- This will make application performance better
		do
			is_nested_output_indented := False
		end

	set_nice_indentation
			-- Turn on the indenting feature that nicely indents nested XML
		do
			is_nested_output_indented := True
		end

feature -- Element change

	put_from_file (file_path: EL_FILE_PATH)
			--
		require
			file_exists: file_path.exists
		do
			put (file_path, Default_source)
		end

	put (a_name: EL_FILE_PATH; template_source: ZSTRING)
			-- compile template and add to global template table
			-- or recompile if file template has been modified
		local
			compiler: EVOLICITY_COMPILER
			is_file_template: BOOLEAN; compiler_table: like Compilers.item
 		do
			log.enter_with_args ("put", << a_name.to_string >>)
			is_file_template := template_source = Default_source
			restrict_access (Compilers)
				compiler_table := Compilers.item
				compiler_table.search (a_name)
				if not compiler_table.found
					or else is_file_template and then a_name.modification_time > compiler_table.found_item.modification_time
				then
					create compiler.make
					if is_file_template then
						compiler.set_encoding_from_other (text_encoding)
						compiler.set_source_text_from_file (a_name)
					else
			 			compiler.set_source_text (template_source)
					end
					compiler.parse
					if compiler.parse_succeeded then
						compiler_table [a_name] := compiler
						log.put_string_field ("Parsed template", a_name.to_string)
						log.put_new_line
					else
						log_or_io.put_line ("Compilation failed")
					end
				end
			end_restriction (Compilers)
			log.exit
		end

	clear_all
			-- Clear all parsed templates
		do
			restrict_access (Compilers)
				Compilers.item.wipe_out
			end_restriction (Compilers)
		end

feature -- Removal

	remove (a_name: EL_FILE_PATH)
			-- remove template
		do
			restrict_access (Compilers)
				Compilers.item.remove (a_name)
			end_restriction (Compilers)
		end

feature -- Basic operations

	merge_to_file (a_name: EL_FILE_PATH; context: EVOLICITY_CONTEXT; file_path: EL_FILE_PATH)
			--
		local
			text_file: EL_PLAIN_TEXT_FILE
		do
			log.enter_with_args ("merge_to_file", << a_name, file_path >>)
			create text_file.make_open_write (file_path)
			text_file.set_encoding_from_other (text_encoding)
			text_file.put_bom
			merge (a_name, context, text_file)
			text_file.close
			log.exit
		end

	merged (a_name: EL_FILE_PATH; context: EVOLICITY_CONTEXT): ZSTRING
			--
		local
			text_medium: EL_ZSTRING_IO_MEDIUM
		do
			log.enter_with_args ("merged", << a_name >>)
			create text_medium.make_open_write (1024)
			text_medium.set_encoding_from_other (text_encoding)
			merge (a_name, context, text_medium)
			text_medium.close
			Result := text_medium.text
			log.exit
		end

	merged_utf_8 (a_name: EL_FILE_PATH; context: EVOLICITY_CONTEXT): STRING
			--
		local
			utf8_text_medium: EL_UTF_STRING_8_IO_MEDIUM
		do
			log.enter_with_args ("merged_utf_8", << a_name >>)
			create utf8_text_medium.make_open_write (1024)
			merge (a_name, context, utf8_text_medium)
			utf8_text_medium.close
			Result := utf8_text_medium.text
			log.exit
		end

	merge (a_name: EL_FILE_PATH; context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		require
			output_writeable: output.is_open_write and output.is_writable
		local
			template: EVOLICITY_COMPILED_TEMPLATE
			found: BOOLEAN; compiler_table: like Compilers.item
		do
			table.search (a_name)
			if table.found then
				template := table.found_item
				found := True
			else
				restrict_access (Compilers)
					compiler_table := Compilers.item
					compiler_table.search (a_name)
					if compiler_table.found then
						-- Changed 23 Nov 2013
						-- Before it used to make a deep_twin of an existing compiled template
						template := compiler_table.found_item.compiled_template
						log.put_string_field ("Compiled template", a_name.to_string)
						log.put_new_line
						table [a_name] := template
						found := True
					else
						log_or_io.put_path_field ("ERROR template", a_name)
						log_or_io.put_string (" not found!")
						log_or_io.put_new_line
					end
				end_restriction (Compilers)
			end
			if found then
				if template.has_file_source and then a_name.modification_time > template.modification_time then
					-- File was modified
					table.remove (a_name)
					put_from_file (a_name)
					-- Try again
					merge (a_name, context, output)
				else
					if attached {EL_UTF_STRING_8_IO_MEDIUM} output as text_output then
						text_output.grow (template.minimum_buffer_length)
					end
					template.execute (context, output)
				end
			end
		end

feature {NONE} -- Implementation

	table: EVOLICITY_TEMPLATE_TABLE
		-- compiled templates

feature {NONE} -- Global attributes

	Compilers: EL_LOGGED_MUTEX_REFERENCE [HASH_TABLE [EVOLICITY_COMPILER, EL_FILE_PATH]]
			-- Global template compilers table
		once ("PROCESS")
			create Result.make (create {like Compilers.item}.make (11))
		end

	Default_source: ZSTRING
		once ("PROCESS")
			create Result.make_empty
		end

end
