
dofile(packageInfo("ca").path.."/examples/parity.lua")

e = Parity{finalTime = 200}

e:execute()

e.map:save("parity.bmp")

clean()
