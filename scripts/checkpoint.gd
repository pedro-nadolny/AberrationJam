extends Area2D

func _on_checkpoint_body_entered(body):
	if body != %Player:
		return
		
	%CheckpointManager.checkpoint_entered(self)
