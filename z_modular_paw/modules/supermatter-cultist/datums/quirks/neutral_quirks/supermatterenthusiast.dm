/datum/quirk/supermatterism
	name = "Supermatterism"
	desc = "You really like being around the Supermatter"
	icon = FA_ICON_GEM
	value = 0
	medical_record_text = "Patient demonstrates a peculiar obsession with the Supermatter Crystal."

/datum/quirk/supermatterism/add(client/client_source)
	RegisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved))

/datum/quirk/supermatterism/remove()
	UnregisterSignal(quirk_holder, COMSIG_MOVABLE_MOVED)
	quirk_holder.clear_mood_event("supermatterism")

/// Called when the quirk holder moves. Updates the quirk holder's mood.
/datum/quirk/supermatterism/proc/on_holder_moved(mob/living/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER

	if(quirk_holder.stat != CONSCIOUS || quirk_holder.IsSleeping() || quirk_holder.IsUnconscious())
		return

	if(HAS_TRAIT(quirk_holder, TRAIT_FEARLESS))
		return

	var/mob/living/carbon/human/human_holder = quirk_holder

	if(istype(human_holder.dna?.species, /datum/species/shadow) || IS_TEAM_DARKSPAWN(human_holder))
		return

	if((human_holder.sight & SEE_TURFS) == SEE_TURFS)
		return

	var/turf/holder_turf = get_turf(quirk_holder)

	var/lums = holder_turf.get_lumcount()

	if(lums > LIGHTING_TILE_IS_DARK)
		quirk_holder.clear_mood_event("supermatterism")
		return

	if(quirk_holder.m_intent == MOVE_INTENT_RUN)
		to_chat(quirk_holder, span_warning("Easy, easy, take it slow... you're in the dark..."))
		quirk_holder.set_move_intent(MOVE_INTENT_WALK)
	quirk_holder.add_mood_event("supermatterism", /datum/mood_event/supermatterism)
