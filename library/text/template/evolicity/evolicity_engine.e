note
	description: "[
		Evolicity template substitution engine.
	
		The templating substitution language was named "Evolicity" as a portmanteau of "Evolve" and "Felicity" 
		which is also a partial anagram of "Velocity" the Apache project which inspired it. 
		It also bows to an established tradition of naming Eiffel orientated projects starting with the letter 'E'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-25 17:18:50 GMT (Thursday 25th July 2013)"
	revision: "3"

class
	EVOLICITY_ENGINE

inherit
	EL_MODULE_LOG
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			create compiled_templates
			set_nice_indentation
		end

feature -- Status query

	is_nested_output_indented: BOOLEAN
		-- is the indenting feature that nicely indents nested XML, active?
		-- Active by default.

	utf8_encoded: BOOLEAN

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

	set_utf8_encoded (a_utf8_encoded: like utf8_encoded)
		do
			utf8_encoded := a_utf8_encoded
		end

feature -- Element change

	set_template_from_file (file_path: EL_FILE_PATH)
			--
		require
			file_exists: file_path.exists
		do
			set_template (file_path, "")
		end

	set_template (a_name: EL_FILE_PATH; template_source: EL_ASTRING)
			-- compile template and add to global template table
			-- or recompile if file template has been modified
		local
			compiler: EVOLICITY_COMPILER
			compiler_table: HASH_TABLE [EVOLICITY_COMPILER, EL_FILE_PATH]
			is_file_template: BOOLEAN
 		do
			log.enter_with_args ("set_template", << a_name.to_string >>)
			is_file_template := template_source.is_empty
			Template_compilers.lock
--			synchronized
				compiler_table := Template_compilers.item
				compiler_table.search (a_name)
				if not compiler_table.found
					or else is_file_template and then a_name.modification_time > compiler_table.found_item.modification_time
				then
					create compiler.make
					if is_file_template then
						compiler.set_is_utf8_source (utf8_encoded)
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
--			end
			Template_compilers.unlock
			log.exit
		end

	clear_all
			-- Clear all parsed templates
		do
			Template_compilers.lock
--			synchronized
				Template_compilers.item.wipe_out
--			end
			Template_compilers.unlock
		end

feature -- Basic operations

	merge_to_file (a_name: EL_FILE_PATH; context: EVOLICITY_CONTEXT; file_path: EL_FILE_PATH)
			--
		local
			text_file: PLAIN_TEXT_FILE
		do
			log.enter_with_args ("merge_to_file", << a_name, file_path >>)
			create text_file.make_open_write (file_path.unicode)
			merge_to_stream (a_name, context, text_file)
			text_file.close
			log.exit
		end

	merged_template (a_name: EL_FILE_PATH; context: EVOLICITY_CONTEXT): EL_ASTRING
			--
		local
			buffer: EL_TEXT_IO_MEDIUM
		do
			log.enter_with_args ("merged_template", << a_name >>)
			create buffer.make_open_write (1024)
			merge_to_stream (a_name, context, buffer)
			buffer.close
			if utf8_encoded then
				create Result.make_from_utf8 (buffer.text)
			else
				create Result.make_from_string (buffer.text)
			end
			log.exit
		end

	merge_to_stream (a_name: EL_FILE_PATH; context: EVOLICITY_CONTEXT; buffer: IO_MEDIUM)
			--
		require
			buffer_writeable: buffer.is_open_write and buffer.is_writable
		local
			template: EVOLICITY_COMPILED_TEMPLATE
			compiler_table: HASH_TABLE [EVOLICITY_COMPILER, EL_FILE_PATH]
			found: BOOLEAN
		do
			compiled_templates.search (a_name)
			if compiled_templates.found then
				template := compiled_templates.found_item
				found := template.has_file_source implies a_name.modification_time ~ template.modification_time
			end
			if not found then
				Template_compilers.lock
--				synchronized
					compiler_table := Template_compilers.item
					compiler_table.search (a_name)
					if compiler_table.found then
						-- Changed 23 Nov 2013
						-- Before it used to make a deep_twin of an existing compiled template
						template := compiler_table.found_item.compiled_template
						log.put_string_field ("Compiled template", a_name.to_string)
						log.put_new_line
						compiled_templates [a_name] := template
						found := True
					else
						log_or_io.put_path_field ("ERROR template", a_name)
						log_or_io.put_string (" not found!")
						log_or_io.put_new_line
					end
--				end
				Template_compilers.unlock
			end
			if found then
				if attached {EL_TEXT_IO_MEDIUM} buffer as memory_file then
					memory_file.grow (template.minimum_buffer_length)
				end
				template.execute (context, buffer, utf8_encoded)
			end
		end

feature {NONE} -- Implementation

	compiled_templates: EVOLICITY_TEMPLATE_TABLE

feature {NONE} -- Global attributes

	Template_compilers: EL_SYNCHRONIZED_REF [HASH_TABLE [EVOLICITY_COMPILER, EL_FILE_PATH]]
			--
		once ("PROCESS")
			create Result.make (create {like Template_compilers.item}.make (11))
		end

end
