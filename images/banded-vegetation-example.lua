
Random{seed = 12345}

dofile(packageInfo("ca").path.."/examples/banded-vegetation-scenario.lua")

BV.map:save("banded-vegetation-example.bmp")

clean()

