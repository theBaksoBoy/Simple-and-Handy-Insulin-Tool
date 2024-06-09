extends ColorRect

@onready var typesList = %TypesList
@onready var nodeContainer = $ScrollContainer/FavoriteShortcutsContainer

var favoriteShortcutScene = preload("res://FavoriteShortcuts/favorite_shortcut_button.tscn")

var favoriteShortcutNodes: Array[Control] = []


func ReloadButtons():
	while len(favoriteShortcutNodes) > 0:
		favoriteShortcutNodes.pop_at(0).queue_free()
	
	for i in range(len(typesList.favorites)):
		var newFavoriteShortcutNode = favoriteShortcutScene.instantiate()
		newFavoriteShortcutNode.foodName = typesList.favorites[i][0]
		newFavoriteShortcutNode.multiplier = typesList.favorites[i][1]
		newFavoriteShortcutNode.hexagonColor = typesList.favorites[i][2]
		newFavoriteShortcutNode.indexInList = i
		nodeContainer.add_child(newFavoriteShortcutNode)
		favoriteShortcutNodes.append(newFavoriteShortcutNode)
		
