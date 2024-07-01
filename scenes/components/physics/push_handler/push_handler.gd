extends Node
class_name PushHandler


func push_objects(body: CharacterBody2D, direction: float = body.velocity.normalized().x) -> void:
	for i in body.get_slide_collision_count():
		var collision := body.get_slide_collision(i)
		
		if collision.get_normal().x != 1 and collision.get_normal().x != -1:
			continue
		
		if collision.get_collider() is PushableObject:
			var collider := collision.get_collider() as PushableObject
			collider.push(Vector2(direction, 0.0))

