const fs = require('fs')

/*
** Regular Expressions
*/
const TIMESTAMP_REGEX = /\[\d+-(?<date>.+)\]/
const GUARD_REGEX = /\].+#(?<id>\d+).+$/


/*
**
** Functional Programming Util
**
*/
const pipe = (...fns) => x => fns.reduce((v, f) => f(v), x)
const last = obj => obj[obj.length - 1]
const sortByVal = h => (
  Object.keys(h).sort((k1, k2) => (
    h[k1] > h[k2] ? 1 : 
      h[k1] < h[k2] ? 
        -1 : 
        0
  ))
)

const buildRange = (
  start, 
  end, 
  arr = []
) => {
  return start >= end ? arr : [start, ...buildRange(start + 1, end, arr.slice(1))];
}

/*
** File I/O
*/
const getLines = path => (
  fs.readFileSync(path)
    .toString()
    .split(/\n/)
)

/*
** Matching Functions
*/
const constructMatcher = regex => line => regex.exec(line) || {}
const getMatchGroup = property => ({ groups = {} }) => groups[property]

/*
** Parsing
*/
const getMinutes = pipe(
  obj => String.prototype.split.call(obj, ":"),
  last,
  parseInt,
  n => n % 60,
)

const getGuardMatch = constructMatcher(GUARD_REGEX)
const getTimeMatch = constructMatcher(TIMESTAMP_REGEX)

const getTime = pipe(getTimeMatch, getMatchGroup('date'))
const getGuard = pipe(getGuardMatch, getMatchGroup('id'))

/*
 * Sorting
 */
const sortByTime = arr => arr.sort((line1, line2) => {
  const time1 = getTime(line1)
  const time2 = getTime(line2)

  if (time1 < time2) return -1
  if (time1 > time2) return 1
  return 0
})


/*
 * 
 * Main
 * 
*/
const partOne = events => {
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
      const start = getMinutes(event)
      const end = getMinutes(events[i + 1])
      const total = end - start
      guard.addTime(total)

      const mins = buildRange(start, end)
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

console.log(
  pipe(
    getLines,
    sortByTime,
    partOne
  )('./input.txt')
)

