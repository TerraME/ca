
dofile(packageInfo("ca").path.."/examples/oscillator.lua")

e = Oscillator{finalTime = 200}

e:execute()

e.map:save("oscillator.bmp")

clean()
