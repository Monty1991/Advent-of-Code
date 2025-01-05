#NoEnv

; --- Day 14: Reindeer Olympics ---
; https://adventofcode.com/2015/day/14

; path to the input file
filePath := "input14.txt"

data := []
loop, read, %filePath%
{
	line := A_LoopReadLine
	if (line == "")
		return

	if (RegexMatch(line, "(\d+)\D*(\d+)\D*(\d+)", m))
		data.push([m1, m2, m3])
}

; We now have more data, and have to race the reindeers altogether
; so we'll make use of objects
class Reindeer {
	__new(speed, runningTime, restTime) {
		this.speed := speed
		this.runningTime := runningTime
		this.restTime := restTime
		this.timeout := runningTime
		this.state := "running"
		this.distanceTravelled := 0
		this.score := 0
	}

	addPoint() {
		this.score++
	}
	
	getScore() {
		return this.score
	}

	tick() {
		if (this.state == "running")
			this.distanceTravelled += this.speed
		this.timeout--
		if (this.timeout > 0)
			return
		switch (this.state) {
			case "running":
				this.timeout := this.restTime
				this.state := "resting"
			case "resting":
				this.timeout := this.runningTime
				this.state := "running"
		}
	}

	getDistanceTravelled() {
		return this.distanceTravelled
	}
}

reindeers := []
for _, stats in data {
	reindeers.push(new Reindeer(stats*))
}

; In this case, we need to reimagine the loop
Race(runners, time) {
	while (time > 0) {
		bestDistance := 0
		for _, runner in runners {
			runner.tick()
			bestDistance := max(bestDistance, runner.getDistanceTravelled())
		}
		for _, runner in runners {
			if (runner.getDistanceTravelled() == bestDistance)
				runner.addPoint()
		}
		time--
	}

	bestScore := 0
	for _, runner in runners {
		bestScore := max(runner.getScore(), bestScore)
	}
	return bestScore
}

msgbox, % "The score of the winning reindeer is: " Race(reindeers, 2503)
