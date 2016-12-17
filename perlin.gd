
export var imgx = 80
export var imgy = 60
export var persistence = 0.7
var SIZE_RECT = 10
var imgAr = []

func perlin(imgx, imgy, persistence):
	var octaves = int(log(max(imgx, imgy)) / log(2))
	print('persistence = ', persistence)
	randomize()
	var imgAr = []
	for j in range(imgy):
		var tmp = []
		for i in range(imgx):
			tmp.append(0.0)
		imgAr.append(tmp)
	var totAmp = 0.0
	for k in range(octaves):
		var freq = pow(2, k)
		var amp = pow(persistence, k)
		totAmp += amp
		var n = freq + 1
		var m = freq + 1 
		var ar = []
		for j in range(m):
			var tmp = []
			for i in range(n):
				tmp.append(randf() * amp)
			ar.append(tmp)

		var nx = imgx / (n - 1.0)
		var ny = imgy / (m - 1.0)
		for ky in range(imgy):
			for kx in range(imgx):
				var i = int(kx / nx)
				var j = int(ky / ny)
				var dx0 = kx - i * nx 
				var dx1 = nx - dx0
				var dy0 = ky - j * ny 
				var dy1 = ny - dy0
				var z = ar[j][i] * dx1 * dy1
				z += ar[j][i + 1] * dx0 * dy1
				z += ar[j + 1][i] * dx1 * dy0
				z += ar[j + 1][i + 1] * dx0 * dy0
				z /= nx * ny
				imgAr[ky][kx] += z
	return [imgAr, totAmp]

func _ready():
	var r
	r = perlin(imgx,imgy, persistence)
	imgAr = r[0]
	var totAmp = r[1]
	for ky in range(imgy):
		for kx in range(imgx):	
			var c = int(imgAr[ky][kx] / totAmp * 255)
			imgAr[ky][kx] = Color(c/1000.0, c/1000.0, c/1000.0)
			print(c,' ',c,' ',c)
	
func _draw():
	var i = 0
	while (i < imgx): 
		var j = 0
		while (j < imgy): 	
			draw_rect(Rect2(Vector2(i * SIZE_RECT, j * SIZE_RECT), Vector2(SIZE_RECT, SIZE_RECT)),imgAr[j][i])
			j+=1
		i+=1