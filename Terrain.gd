

extends Spatial
export(OpenSimplexNoise) var noise
export(float) var noiseScale
export(bool) var regenerate setget regenSet
export(int) var chunkSize
export(int) var mapWidth
export(int) var mapHeight


var mapLoading = true
var mutex
var threads = []
var lazyThreads = []
var workList = []

var numberThreads = 8






func generateMap(cs, mw, mh):
	mutex = Mutex.new()
	# Make threads for map generator
	for i in numberThreads:
		var tempThread = Thread.new()
		print("Made thread: ", tempThread.is_active())
		lazyThreads.push_back(tempThread)
	
	
	
	# Make data for map generator
	for i in mh:
		for j in mw:
			var xoffset = i * cs
			var yoffset = j * cs
			var threadData = [cs, xoffset, yoffset, noise, noiseScale, mutex]
			workList.push_front(threadData)
			

			


func assignLazyThreads():
	
	var lazy = lazyThreads.pop_back()
	if lazy != null:
		# We have a thread
		mutex.lock()
		var thrdData = workList.pop_back()
		mutex.unlock()
		if thrdData != null:
			print("Thread: ", lazy)
			thrdData.push_back(lazy)
			if lazy.is_active():
				lazy.wait_to_finish()
				
			lazy.start(self, "getChunk", thrdData)
			
		
		
func _process(_delta):
	# 2 thread lists, lazy and active
	assignLazyThreads()
	
	
	

			

			
			
func getChunk(data):
	print("Getting chunk for data: ", data)
	mutex.lock()
	var MapGen = load("res://MapGenerator.gd").new()
	mutex.unlock()
	MapGen.setChunk(data[0])
	var chunkData = MapGen.generateLandscape(data)	
	
	var chunkMesh = MeshInstance.new()
	chunkMesh.mesh = chunkData[0]
	call_deferred("add_child", chunkMesh)
	print("Thread has finished")
	mutex.lock()
	lazyThreads.push_back(data[6])
	mutex.unlock()
	
	


func clearMap():
	for i in range(0, get_child_count()):
		get_child(i).queue_free()	



func _ready():
	clearMap()
	generateMap(chunkSize, mapWidth, mapHeight)	
	
	
func regenSet(_regen):
	regenerate = true
	print("Regenerating map")
	clearMap()
	generateMap(chunkSize, mapWidth, mapHeight)
	

	
	



	






	
