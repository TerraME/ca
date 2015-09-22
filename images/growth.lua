
dofile(packageInfo("ca").path.."/examples/growth.lua")

e = Growth{finalTime = 100}

e:execute()

e.map:save("growth.bmp")

clean()
