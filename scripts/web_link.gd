class_name WebLink
extends RigidBody2D

#TODO: figure out how to set this correctly/retrieve before instantiation
# TODO: make link length dynamic 
static var LINK_LENGTH: float = 40.0

# @export var max_length: float = 60.0
# @export var min_length: float = 20.0
# @export var link_height: float = 5.0

func _ready() -> void:
    pass

func _draw() -> void:
    pass

# func update_link_length(angle_delta: float) -> float:
#     var new_length: float
#     if angle_delta < 0.1:
#         new_length = max_length
#     elif angle_delta >= 0.1 and angle_delta <= 0.6:
#         new_length = lerp(min_length, max_length, remap(angle_delta, 0.1, 0.6, 0, 1))
#     else:
#         new_length = min_length

#     $CollisionShape2D.shape.size.x = new_length
#     var polygon_arr = [
#         Vector2(-new_length/2, link_height/2),
#         Vector2(new_length/2, link_height/2),
#         Vector2(new_length/2, -link_height/2),
#         Vector2(-new_length/2, -link_height/2),
#     ]
#     $Polygon2D.polygon = PackedVector2Array(polygon_arr)
#     LINK_LENGTH = new_length
#     return new_length