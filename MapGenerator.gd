extends Spatial


var chunkSize
var width
var height
var noise = null
var noiseScale
var tempMesh
var vertices
var UVs
var normals
var mutex

func createQuad(x, y):
	var vert1 # vertex positions (Vector2)
	var vert2
	var vert3
	
	var side1 # sides of each triangle (Vector3)
	var side2
	
	var normal # normal for each triangle (Vector3)
	
	# triangle 1
	vert1 = Vector3(x, getNoise(x, -y), -y)
	vert2 = Vector3(x,   getNoise(x, -y-1), -y-1)
	vert3 = Vector3(x+1, getNoise(x+1, -y-1), -y-1)
	vertices.push_back(vert1)
	vertices.push_back(vert2)
	vertices.push_back(vert3)
	
	UVs.push_back(Vector2(vert1.x/10, -vert1.z/10))
	UVs.push_back(Vector2(vert2.x/10, -vert2.z/10))
	UVs.push_back(Vector2(vert3.x/10, -vert3.z/10))
	
	side1 = vert2-vert1
	side2 = vert2-vert3
	normal = side1.cross(side2)
	
	for _i in range(0,3):
		normals.push_back(normal)
	
	# triangle 2
	vert1 = Vector3(x, getNoise(x, -y), -y)
	vert2 = Vector3(x+1, getNoise(x+1, -y-1), -y-1)
	vert3 = Vector3(x+1, getNoise(x+1, -y), -y)
	vertices.push_back(vert1)
	vertices.push_back(vert2)
	vertices.push_back(vert3)
	
	UVs.push_back(Vector2(vert1.x/10, -vert1.z/10))
	UVs.push_back(Vector2(vert2.x/10, -vert2.z/10))
	UVs.push_back(Vector2(vert3.x/10, -vert3.z/10))
	
	side1 = vert2-vert1
	side2 = vert2-vert3
	normal = side1.cross(side2)
	
	for _i in range(0,3):
		normals.push_back(normal)


func getNoise(x, y):
	if noise != null:
		return noise.get_noise_2d(x, y) * noiseScale
	else:
		return 0

func setChunk(size):
	chunkSize = size
	
func generateLandscape(chunkData):
	var xoffset = chunkData[1]
	var yoffset = chunkData[2]
	noise       = chunkData[3]
	noiseScale  = chunkData[4]
	mutex = chunkData[5]

	tempMesh = Mesh.new()
	vertices = PoolVector3Array()
	UVs      = PoolVector2Array()
	normals  = PoolVector3Array()
	
	for x in range(0, chunkSize):
		for y in range(0, chunkSize):
			createQuad(x + xoffset, y + yoffset)
			
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	mutex.lock()
	st.set_material(load("res://mat.tres"))
	mutex.unlock()
			
	for v in vertices.size():
		st.add_uv(UVs[v])
		st.add_normal(normals[v])
		st.add_vertex(vertices[v])
	
	st.commit(tempMesh)
	var shape = ConcavePolygonShape.new()
	shape.set_faces(tempMesh.get_faces())
	return [tempMesh, shape]
	

	
	

		


