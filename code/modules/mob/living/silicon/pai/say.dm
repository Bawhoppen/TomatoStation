<<<<<<< HEAD
/mob/living/silicon/pai/say(msg)
	if(silent)
		to_chat(src, "<span class='warning'>Communication circuits remain unitialized.</span>")
	else
		..(msg)

/mob/living/silicon/pai/binarycheck()
	return 0
=======
/mob/living/silicon/pai/say(msg)
	if(silent)
		to_chat(src, "<span class='warning'>Communication circuits remain unitialized.</span>")
	else
		..(msg)

/mob/living/silicon/pai/binarycheck()
	return 0
>>>>>>> 228af28... initial commit
