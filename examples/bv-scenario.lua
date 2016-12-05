-- @example A scenario for the BandedVegetation model.
-- @image banded-vegetation-example.bmp

import("ca")

BV = BandedVegetation{
	plantCover = 0.4,
	dryCoeff = 1.2,
	wetCoeff = 0.7,
	distributeLaterally = true,
	distributeToSecondNeighbors = true,
	rainDecrease = false,
	finalTime = 20
}

BV:run()


