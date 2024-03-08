extends Area2D

func _on_checkpoint_body_entered(body):
	if body != %Player:
		return
	
	body_entered.disconnect(_on_checkpoint_body_entered)
	%CheckpointManager.checkpoint_entered(self)
