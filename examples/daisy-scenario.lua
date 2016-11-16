
-- @example Daisy world example with larger range of reproducing temperature
-- and more life span.
-- @image daisy-example.bmp
import("ca")

instance = DaisyWorld{
	proportion = {
		empty = 0.5,
		white = 0.1
	},
	reproduceTemperature = {
		min = 0,
		max = 100
	},
	lifeSpan = 10
}

instance:run()
