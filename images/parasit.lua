
dofile(packageInfo("ca").path.."/examples/parasit.lua")

e = Parasit{finalTime = 200}

e:execute()

e.map:save("parasit.bmp")

clean()
