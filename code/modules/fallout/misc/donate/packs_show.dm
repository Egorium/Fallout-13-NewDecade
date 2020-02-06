/datum/preferences/proc/ShowContentPacks(mob/user)
	var/packs_data
	for(var/P in SScontent.all_content_packs)
		var/classes
		if(P in parent.content_packs)
			classes += "have"
		if(P == selected_pack)
			classes += " linkOn"
		var/datum/content_pack/pack = SScontent.get_pack(P)
		packs_data += "<a class='[classes]' href='?_src_=prefs;preference=content_packs;pack=[pack.id]' data-tooltip=\"[quoter(pack.desc)]\">[pack.name]</a><br>"
	var/list/spack_data = list()
	if(!selected_pack)
		selected_pack = "starter"

	var/datum/content_pack/pack = SScontent.get_pack(selected_pack)
	spack_data["name"] = "[pack.name]"
	spack_data["desc"] = "[pack.desc]"
	spack_data["price"] = "[pack.price]"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     