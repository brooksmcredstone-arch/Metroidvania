class_name ItemData extends Resource

enum ItemCategory {CONSUMABLE, WEAPON, ARMOR, ACCESSORY, KEYITEM}
enum ItemEffectType {NONE, HEAL, RESTORE_MP, CURE_STATUS}

@export var name : String = ""
@export var description : String = ""
@export var texture : Texture2D
@export var category : ItemCategory
@export var quantity : int = 1
@export var atk_bonus : int = 0
@export var matk_bonus : int = 0
@export var def_bonus : int = 0
@export var mdef_bonus : int = 0

#region /// Use Effects
@export var effect_type : ItemEffectType = ItemEffectType.NONE
@export var effect_value : float = 0.0
@export var effect_duration : float = 0.0
#endregion
