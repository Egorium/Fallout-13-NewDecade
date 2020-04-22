//checks if a file exists and contains text
//returns text as a string if these conditions are met
/proc/return_file_text(filename)
	if(fexists(filename) == 0)
		throw EXCEPTION("return_file_text(): File not found")
		return

	var/text = file2text(filename)
	if(!text)
		throw EXCEPTION("return_file_text(): File empty")
		return

	return text

//Sends resource files to client cache
/client/proc/getFiles()
	for(var/file in args)
		src << browse_rsc(file)

/client/proc/browse_files(root="data/logs/", max_iterations=10, list/valid_extensions=list(".txt",".log",".htm"))
	var/path = root

	for(var/i=0, i<max_iterations, i++)
		var/list/choices = flist(path)
		if(path != root)
			choices.Insert(1,"/")

		var/choice = input(src,"Choose a file to access:","Download",null) as null|anything in choices
		switch(choice)
			if(null)
				return
			if("/")
				path = root
				continue
		path += choice

		if(copytext(path,-1,0) != "/")		//didn't choose a directory, no need to iterate again
			break

	var/extension = copytext(path,-4,0)
	if( !fexists(path) || !(extension in valid_extensions) )
		to_chat(src, "<font color='red'>Error: browse_files(): File not found/Invalid file([path]).</font>")
		return

	return path

#define FTPDELAY 200	//200 tick delay to discourage spam
/*	This proc is a failsafe to prevent spamming of file requests.
	It is just a timer that only permits a download every [FTPDELAY] ticks.
	This can be changed by modifying FTPDELAY's value above.

	PLEASE USE RESPONSIBLY, Some log files can reach sizes of 4MB!	*/
/client/proc/file_spam_check()
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: file_spam_check(): Spam. Please wait [round(time_to_wait/10)] seconds.</font>")
		return 1
	fileaccess_timer = world.time + FTPDELAY
	return 0
#undef FTPDELAY

/proc/pathwalk(path)
	var/list/jobs = list(path)
	var/list/filenames = list()

	while(jobs.len)
		var/current_dir = pop(jobs)
		var/list/new_filenames = flist(current_dir)
		for(var/new_filename in new_filenames)
			// if filename ends in / it is a directory, append to currdir
			if(findtext_char(new_filename, "/", -1))
				jobs += current_dir + new_filename
			else
				filenames += current_dir + new_filename
	return filenames

/proc/pathflatten(path)
	return replacetext(path, "/", "_")
