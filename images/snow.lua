
dofile(packageInfo("ca").path.."/examples/snow.lua")

e = Snow{finalTime = 250}

e:execute()

e.map:save("snow.bmp")

clean()
