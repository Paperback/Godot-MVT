class_name LayerTileRequestJob extends RequestJob

var tile: MvtLayerTiles
var url: Dictionary
var x: int
var y: int
var z: int
func _init(requester: Node, callback: String, tile: MvtLayerTiles, url: Dictionary, x: int, y: int, z: int).(requester, callback):
	self.tile = tile
	self.url = url
	self.x = x
	self.y = y
	self.z = z

var response: PoolByteArray
func _load() -> Array:
	var filename = "%s/%s-%s.pbf" % [z, x, y]
	var dir := State.mapsdir(tile.layer.id.split('.').join('/')+'/pbf/'+filename)
	var directory = Directory.new()
	if not directory.file_exists(dir): # and !State.feature.overwrite:
		response = .request(url.host, str(url.port), url.path)
		State.save_pbf(tile.layer.id, filename, response)
#	else:
#		var f = File.new()
#		f.open(dir, File.READ)
#		response = f.get_buffer(f.get_len())
#		f.close()
	if State.feature.resource and response.size() > 0:
		_import_resource(response)
	return []

var MvtImporter = load("res://addons/mvt/MvtTile.cs")
func _import_resource(response: PoolByteArray):
	var resource: MvtTile = MvtTile.new(tile.layer, tile, x, y, z)
	var mvt = MvtImporter.new()
	mvt.import(self, response, tile.layer.table)
	mvt.queue_free()
	resource.geometry = geometry
	geometry = []
	if not resource.geometry.empty():
		State.save_tile(resource)
#		ResourceSaver.save(location + "/%s-%s.tres" % [x, y], data)

var geometry: Array = []
func geometry_add(geom: PoolVector2Array, name: String):
	geometry.append(geom)

#func import(name: String, pbf: String, x: int, y: int, z: int):
#	var layer: MvtLayer = layers[name]
#
#	#Log.verbose('Importing %s: %s' % [name, pbf])
#	var location = "%s/%s/%s/%s" % [layer.project, layer.table, 'resources', z]
#	var location2 = "%s/%s" % [layer.project, layer.table]
#	var directory: Directory = Directory.new()
#	directory.make_dir_recursive(location)
#	var data = MvtTile.new()
#	data.layer = layer
#	data.position.x = x
#	data.position.y = y
#	data.zoom = z
#	var file = File.new()
#	if file.open(pbf, File.READ) != OK:
#		Log.warning('failed to open %s' % pbf)
#
#		ResourceSaver.save(location + "/%s-%s.tres" % [x, y], data)
#	else:
#		var buffer = file.get_buffer(file.get_len())
#		var mvt = preload("res://addons/mvt/MvtTile.cs").new()
#		geometry[name] = []
#		var tile = mvt.import(self, buffer, name)
#		file.close()
#		data.geometry = geometry[name]
#		ResourceSaver.save(location + "/%s-%s.tres" % [x, y], data)
#		#ResourceSaver.save(location2 + "/layer.tres", layer)


