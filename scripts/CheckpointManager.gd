extends Node2D

var last_checkpoint = -1

func checkpoint_entered(checkpoint):
	var checkpoint_id = get_children().find(checkpoint)	
	
	if last_checkpoint >= checkpoint_id:
		return
		
	print(checkpoint_id)
	last_checkpoint = checkpoint_id
	%Spawn.position = checkpoint.position
