
import("ca")

e = InterspecificCompetition{finalTime = 80}

e:run()

e.map:save("interspecific-competition.bmp")

clean()
