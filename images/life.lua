
Random{seed = 12345}

import("ca")

life = Life{finalTime = 15}

life:execute()

life.map:save("life.bmp")
clean()

