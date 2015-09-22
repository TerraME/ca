
dofile(packageInfo("ca").path.."/examples/excitable.lua")

e = Excitable{finalTime = 20}

e:execute()

e.map:save("excitable.bmp")

clean()
