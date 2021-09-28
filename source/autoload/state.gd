extends Node

var project: String = ''
var host: String = ''
var port: String = ''
var feature: Dictionary = {
	'overwrite': true,
	'pbf': true,
	'resource': false
}
func mapsdir(path: String = '') -> String:
	return project+'/'+path

func url(path: String = '') -> String:
	return "http://%s:%s/%s" % [ host, port, path ]

func save_layer(layer: MvtLayer):
	var dir := mapsdir(layer.id.split('.').join('/')+'/res/layer.tres')
	#print(dir)
	var directory = Directory.new()
	if not directory.dir_exists(dir.get_base_dir()): directory.make_dir_recursive(dir.get_base_dir())
	#layer.tiles = []
	ResourceSaver.save(dir, layer, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
	
func save_tile(tile: MvtTile):
	var dir := mapsdir(tile.layer.id.split('.').join('/')+'/res/'+'%s/%s-%s.tres' % [tile.z, tile.x, tile.y])
	print(dir)
	var directory = Directory.new()
	if not directory.dir_exists(dir.get_base_dir()): directory.make_dir_recursive(dir.get_base_dir())
	ResourceSaver.save(dir, tile, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)

func save_pbf(layer: String, filename: String, data: PoolByteArray) -> bool:
	var dir := mapsdir(layer.split('.').join('/')+'/pbf/'+filename)
	var directory = Directory.new()
	if not directory.dir_exists(dir.get_base_dir()): directory.make_dir_recursive(dir.get_base_dir())
	var file := File.new()
	var err = file.open(dir, File.WRITE_READ)
	if err != OK: 
		Log.error(err)
		Log.error(dir)
		return false
	else:
		file.store_buffer(data)
		file.close()
		return true
