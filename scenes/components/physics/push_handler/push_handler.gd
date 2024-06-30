extends Node
class_name PushHandler


func push_objects(body: CharacterBody2D) -> void:
	for i in body.get_slide_collision_count():
		var collision := body.get_slide_collision(i)
		if collision.get_normal() == body.up_direction:
			continue
		
		if collision.get_collider() is PushableObject:
			var collider := collision.get_collider() as PushableObject
			collider.push(Vector2(body.velocity.normalized().x, 0.0))

