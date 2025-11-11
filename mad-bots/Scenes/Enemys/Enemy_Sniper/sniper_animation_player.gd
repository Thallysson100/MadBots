extends Enemy_AnimationPlayer


func match_animation(anim_name: String) -> void:
	match anim_name:
		"death":
			can_play_new_animation = false  # Lock animations during death
			spriteDeath.visible = true  # Show death sprite
		"taking_damage":
			if not spriteDeath.visible:  # Only allow if death animation is not active
				can_play_new_animation = false  # Lock animations during damage
				spriteHurt.visible = true  # Show hurt sprite
		"attack":
			if not spriteDeath.visible and not spriteHurt.visible:  # Only allow if death or damage animation is not active
				spriteAttack.visible = true  # Show attack sprite
		"walk":
			if not spriteDeath.visible and not spriteHurt.visible and not spriteAttack.visible:  # Only allow if no higher-priority animations are active
				spriteWalk.visible = true  # Show walk sprite
		_:
			# Default case (should not be reached)
			assert(false, "Unknown animation: " + anim_name)
