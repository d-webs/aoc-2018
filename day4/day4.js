const fs = require('fs')
const TIMESTAMP_REGEX = /\[\d+-(?<date>.+)\]/
const GUARD_REGEX = /\].+#(?<id>\d+).+$/

/*
**
** Utility functions
**
*/
const getLines = path => (
  fs.readFileSync(path)
    .toString()
    .split(/\n/)
)
const pipe = (...fns) => x => fns.reduce((v, f) => f(v), x)
const last = obj => obj[obj.length - 1]
const getMinutes = pipe(
  obj => String.prototype.split.call(obj, ":"),
  last,
  parseInt,
  n => n % 60,
)

const getHours = pipe(
  obj => /\s(\d+):/.exec(obj),
  obj => obj[1],
  parseInt,
  n => n / 60,
  Math.floor
)

const sortByVal = h => Object.keys(h).sort((k1, k2) => h[k1] > h[k2] ? 1 : (h[k1] < h[k2] ? -1 : 0)) 
const constructMatcher = regex => line => regex.exec(line) || {}
const getMatchGroup = property => ({ groups = {} }) => groups[property]

const getGuardMatch = constructMatcher(GUARD_REGEX)
const getTimeMatch = constructMatcher(TIMESTAMP_REGEX)

const getTime = pipe(getTimeMatch, getMatchGroup('date'))
const getGuard = pipe(getGuardMatch, getMatchGroup('id'))

const getMinutesArr = (t1, t2) => {
  let _t1 = t1
  const allMinutes = []
  while (_t1 < t2) {
    let mins = getMinutes(_t1)
    let hours = getHours(_t1)
    allMinutes.push(mins)

    mins += 1
    if (Math.floor(mins / 60)) {
      hours += 1
      mins %= 60

      if (hours > 24) console.log('uh oh')
    }

    _t1 = _t1.replace(/\d+:\d+/, `${hours ? hours : '00'}:${mins}`)
  }

  return allMinutes
}


/*
** Part One
*/
const partOne = () => {
  const events = getLines('./input.txt').sort((line1, line2) => {
    const time1 = getTime(line1)
    const time2 = getTime(line2)

    if (time1 < time2) return -1
    if (time1 > time2) return 1
    return 0
  })

  let current
  const guards = {}
  for (let i = 0; i < events.length - 1; i++) {
    const event = events[i]
    
    let id = getGuard(event)
    if (id) {
      if (typeof guards[id] === 'undefined') {
        guards[id] = new Guard(id)
      }
      
      current = id
      continue
    }

    if (event.includes('asleep')) {
      const guard = guards[current];
      const start = getTime(event)
      const end = getTime(events[i + 1])
      const total = new Date(end) - new Date(start)
      guard.addTime(total)

      const mins = getMinutesArr(event, events[i + 1])
      for (let i = 0; i < mins.length; i++) {
        const minute = mins[i]
        let minuteCount = guard.minutes[minute]
        guard.minutes[minute] =
          minuteCount ? 
          minuteCount + 1 :
          1
      }
    }
  }

  const [winner] = Object.keys(guards).sort((k1, k2) => (
    guards[k1].total < guards[k2].total ? 1 : (
      guards[k1].total > guards[k2].total ?
       -1 : 0
    )
  ))

  return parseInt(winner) * parseInt(guards[winner].mostCommonMinute())
}

class Guard {
  constructor(id) {
    this.total = 0
    this.minutes = {}
    this.id = id
  }
  
  addTime(time) {
    this.total += time
  }

  mostCommonMinute() {
    return pipe(sortByVal, last)(this.minutes);
  }
}

partOne()

