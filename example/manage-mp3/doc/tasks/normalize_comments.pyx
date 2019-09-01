pyxis-doc:
	version = 1.0; encoding = "UTF-8"

# rename comment description 'Comment' as 'c0'
# This is an antidote to a bug in Rhythmbox version 2.97 where editions to
# 'c0' command are saved as 'Comment' and are no longer visible on reload.

task_config:
	task = normalize_comments; is_dry_run = false

