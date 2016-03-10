note
	description: "Summary description for {TEST_STRING_TYPES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "5"

deferred class
	STRING_TESTS [S -> STRING_GENERAL create make_empty end]

inherit
	EL_MODULE_LOG
	EL_MODULE_STRING
	EL_MODULE_EIFFEL

	MEMORY
	STRING_HANDLER

feature {NONE} -- Initialization

	make (a_string_list: ARRAYED_LIST [STRING_32])
		do
			log.enter ("make")
			create routines.make (11)
			create results_ms.make (11)
			create string_list.make (a_string_list.count)
			create words_list.make (a_string_list.count)

			name := create_name

			do_test ("set_string_list", agent set_string_list (a_string_list))
			do_test ("set_lower_case", agent set_lower_case)
			do_test ("split_into_words", agent split_into_words)
			do_test ("set_unique_words", agent set_unique_words)
			do_test ("quick_sort", agent quick_sort)
			do_test ("remove_words_from_head", agent remove_words_from_head)
			do_test ("append_words", agent append_words)
			do_test ("prepend_words", agent prepend_words)
			do_test ("count_integer_words", agent count_integer_words)
			do_test ("count_occurrences_of_and", agent count_occurrences_of_and)
			do_test ("to_unicode_32", agent to_unicode_32)

			log.put_integer_field ("Total millisecs", total_time_ms)

			create string_list.make (0)
			create words_list.make (0)
			full_collect

			log.exit
		end

feature -- Access

	routines: ARRAYED_LIST [STRING]

	results_ms: ARRAYED_LIST [INTEGER]

	total_time_ms: INTEGER

	total_mega_bytes: DOUBLE
		local
			bytes: INTEGER
		do
			across string_list as s loop
				bytes := bytes + storage_bytes (s.item)
			end
			Result := bytes / 1000000
		end

	name: ASTRING

feature -- Tests

	set_string_list (a_string_list: ARRAYED_LIST [STRING_32])
		do
			across a_string_list as l_string loop
				string_list.extend (create_string (l_string.item))
			end
			log.put_integer_field (" String count", string_list.count)
		end

	split_into_words
		local
			count: INTEGER
		do
			from string_list.start until string_list.after loop
				words_list.extend (string_list.item.split (' '))
				count := count + words_list.last.count
				string_list.forth
			end
			log.put_integer_field (" Total words", count)
		end

	set_unique_words
		do
			create unique_words.make (10000)
			across words_list as words loop
				across words.item as word loop
					unique_words.put (word.item)
				end
			end
			log.put_integer_field (" Total unique words", unique_words.count)
		end

	set_lower_case
		do
			from string_list.start until string_list.after loop
				string_list.replace (string_list.item.as_lower)
				string_list.forth
			end
		end

	quick_sort
		local
			sortable_array: SORTABLE_ARRAY [S]
		do
			create sortable_array.make_from_array (unique_words.linear_representation.to_array)
			sortable_array.sort
		end

	remove_words_from_head
		local
			paragraph: S
			pos_space: INTEGER
		do
			from string_list.start until string_list.after loop
				paragraph := string_list.item.twin
				from until paragraph.is_empty loop
					pos_space := index_of (' ', paragraph)
					if pos_space > 0 then
						paragraph.keep_tail (paragraph.count - pos_space)
					else
						paragraph.keep_tail (0)
					end
				end
				string_list.forth
			end
		end

	append_words
		local
			s: S
		do
			across words_list as words loop
				create s.make_empty
				across words.item as word loop
					if not s.is_empty then
						s.append_code (32)
					end
					s.append (word.item)
				end
			end
		end

	prepend_words
		local
			s: S
			space: S
		do
			space := create_string (" ")
			across words_list.new_cursor.reversed as words loop
				create s.make_empty
				across words.item as word loop
					if not s.is_empty then
						s.prepend (space)
					end
					s.prepend (word.item)
				end
			end
		end

	count_occurrences_of_and
		local
			occurrences: INTEGER
			and_str: S
		do
			and_str := create_string ("and")
			from string_list.start until string_list.after loop
				occurrences := occurrences + count_occurrence (and_str, string_list.item)
				string_list.forth
			end
			log.put_integer_field (" Count", occurrences)
		end

	count_integer_words

		local
			count: INTEGER
		do
			across unique_words as word loop
				if word.item.is_integer then
					count := count + 1
				end
			end
			log.put_integer_field (" Integer words", count)
		end

	to_unicode_32
		local
			l_unicode: STRING_32
		do
			from string_list.start until string_list.after loop
				l_unicode := create_unicode (string_list.item)
				string_list.forth
			end
		end

feature {NONE} -- Implementation

	create_name: ASTRING
		do
			Result := create_string ("").generator
		end

	do_test (a_name: STRING; procedure: PROCEDURE [like Current, TUPLE])
		local
			timer: EL_EXECUTION_TIMER
		do
			log.put_string_field ("Test", a_name)
			create timer.make
			procedure.apply
			timer.stop
			log.put_integer_field (" Millisecs", timer.elapsed_millisecs)
			log.put_new_line

			routines.extend (a_name)
			results_ms.extend (timer.elapsed_millisecs)
			total_time_ms := total_time_ms + timer.elapsed_millisecs
		end

	count_occurrence (str, target: S): INTEGER
		local
			i: INTEGER
		do
			from i := 1 until i = 0 or i > target.count loop
				i := target.substring_index (str, i)
				if i > 0 then
					i := i + str.count
					Result := Result + 1
				end
			end
		end

	index_of (uc: CHARACTER_32; s: S): INTEGER
		deferred
		end

	create_string (unicode: STRING_32): S
		deferred
		end

	create_unicode (s: S): STRING_32
		deferred
		end

	storage_bytes (s: S): INTEGER
		deferred
		end

	string_list: ARRAYED_LIST [S]

	words_list: ARRAYED_LIST [LIST [S]]

	unique_words: EL_HASH_SET [S]

end
