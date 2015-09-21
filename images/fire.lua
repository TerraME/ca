
Random{seed = 12345}

import("ca")

fire = Fire{finalTime = 15}

fire:execute()

fire.map:save("fire.bmp")
clean()

