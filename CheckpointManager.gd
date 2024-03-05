extends Node2D

var last_checkpoint = 0

func checkpoint_entered(checkpoint):
	var checkpoint_id = get_children().find(checkpoint)	
	
	if last_checkpoint > checkpoint_id:
		return
		
	%Spawn.position = checkpoint.position
