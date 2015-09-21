
Random{seed = 12345}

import("ca")

anneal = Anneal{}

anneal:execute()

anneal.map:save("anneal.bmp")
clean()

