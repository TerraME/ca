
Random{seed = 12345}

dofile(packageInfo("ca").path.."/examples/daisy-scenario.lua")

instance.map1:save("daisy-example.bmp")

clean()

