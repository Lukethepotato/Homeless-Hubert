extends Resource
class_name ailment

@export var turn_amount: int = 2
@export var lock_block: bool = false #if false then not locked
@export var force_attack: attack_parent # will force the recipent to do this attack for the turn amount each turn unless its "" (note the animation name must be the same on both enemy and player)
@export var force_immediate_attack: attack_parent #will force the recipient to do this attack the second they recieve the ailment (ignore if "")
@export var damage_take_per_turn: int
@export var animation_name: String #if not set to anything the characters animation wont change
@export var ailment_icon: Texture2D
@export var animation_priority: int #if this ailment has a animation this defines the likeliness that it will be played over other ailments animations
@export var attacks_per_turn_set: int # set less than 0 to make ignore

@export_group("Stat Modification")
@export var stat_to_change : GlobalsAutoload.stats;
@export var modifier : GlobalsAutoload.modifiers;
@export var value : float;

#wanna have somthing like an overlay or someway to change the shader
#but dont know how to make
