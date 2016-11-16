
Random{seed = 12345}

import("ca")

solid = SolidDiffusion{}

solid:run()

solid.map:save("solid.bmp")
clean()

